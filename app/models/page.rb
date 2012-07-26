class Page < ActiveRecord::Base

  MATCHED_SYMBOLS = 'a-zA-Z0-9_'

  belongs_to :parent, class_name: :Page, foreign_key: :page_id
  has_many :children, class_name: :Page
  attr_accessible :name, :text, :title
  validates :name,
    :uniqueness => { :scope => :page_id },
    :format => { :with => %r{\A[#{MATCHED_SYMBOLS}]+\Z}i },
    :exclusion => { :in => %w( add edit ) }
  validate :root_page_is_unique, :if => :root?

  before_save :parse_page

  # Search page by her route path. If page not found raise ActiveRecord::RecordNotFound
  #
  # @param [String] path route path to page
  # @return [Page]
  def self.find_by_path(path)
    if path and (page_names = names_from_path(path)).size > 1
      page_names.drop(1).inject(root!) {|page, page_name| page.children.find_by_name!(page_name) }
    else
      root!
    end
  end

  # Search root page
  #
  # @return [Page, nil]
  def self.root
    find_by_page_id(nil)
  end

  # Search root page and raise ActiveRecord::RecordNotFound overwise
  #
  # @return [Page]
  def self.root!
    find_by_page_id!(nil)
  end

  def root?
    !parent
  end

  # Route path for this page
  #
  # @return [String] path starts with '/'
  def path
    if self.root?
      self.name
    else
      page = self
      page_names = [page.name]
      page_names.unshift(page.name) while page = page.parent
      page_names.join('/')
    end
  end

  # All subpages in specified Array
  #
  # @return [Array<Page, Array>] found subpages seen as
  #   [page, [
  #     [subpage1, [
  #       [subsubpage1, [...]],
  #       ...]],
  #     [subpage2, [...]],
  #     ...]]
  def subpages
    [self, self.children.map(&:subpages)]
  end

  private

    # validate of single root page
    def root_page_is_unique
      errors.add(:page_id, :root_page_is_not_unique) if self.class.exists?(:page_id => nil)
    end

    # get list page names from route path
    #
    # @param [String] path route path
    # @return [Array] list of page names
    def self.names_from_path(path)
      path.split('/').delete_if(&:blank?)
    end

    def parse_page
      self.text = PageParser.to_html(self.text)
    end
end
