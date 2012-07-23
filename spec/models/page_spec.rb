require 'spec_helper'

describe Page do
  let(:root_page) { FactoryGirl.create(:root_page) }
  let(:sub1_page) { FactoryGirl.create(:sub1_page) }
  let(:sub1sub1_page) { FactoryGirl.create(:sub1sub1_page) }
  it { should allow_mass_assignment_of(:name) }
  it { should validate_format_of(:name).with('correct_page_name') }
  it { should validate_format_of(:name).not_with('!ncorrect_page_name') }
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:text) }
  it { should_not allow_mass_assignment_of(:page_id) }
  it { root_page; should validate_uniqueness_of(:name).scoped_to(:page_id) }
  it { root_page; FactoryGirl.build(:another_root_page).should be_invalid }
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  describe "::root" do
    it { root_page.should be == described_class.root }
  end
  describe '#root?' do
    it { root_page.should be_root }
    it { sub1_page.should_not be_root }
  end
  describe "::find_by_path" do
    it { described_class.find_by_path(root_page.path).should be == root_page }
    it { described_class.find_by_path(sub1_page.path).should be == sub1_page }
    it { described_class.find_by_path(sub1sub1_page.path).should be == sub1sub1_page }
  end

  describe "#path" do
    it { root_page.path.should be == "/" }
    it { sub1_page.path.should be == "/#{sub1_page.name}" }
    it { sub1sub1_page.path.should be == "/#{sub1sub1_page.parent.name}/#{sub1sub1_page.name}" }
  end
end
