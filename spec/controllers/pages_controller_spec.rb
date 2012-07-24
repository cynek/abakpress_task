require 'spec_helper'

describe PagesController do

  let(:not_existing_path) { 'not/existing/page' }
  shared_examples_for "with not found page without root" do
    it { should redirect_to(add_root_path) }
  end
  shared_examples_for "with not found page with root" do
    it { should redirect_to(root_path) }
  end

  describe "GET 'show'" do
    context 'without root' do
      it_behaves_like("with not found page without root") { subject { get :show, path: not_existing_path } }
    end
    context "with root" do
      before do
        @root_page = FactoryGirl.create(:root_page)
      end
      let(:sub1sub1_page) { FactoryGirl.create(:sub1sub1_page, parent: FactoryGirl.create(:sub1_page, parent: @root_page)) }
      subject { get :show, path: sub1sub1_page }
      it_behaves_like("with not found page with root") { subject { get :show, path: not_existing_path } }
      it "returns http success" do
        subject.should be_success
      end
    end
  end

  describe "GET 'edit'" do
    context 'without root' do
      it_behaves_like("with not found page without root") { subject { get :edit, path: not_existing_path } }
    end
    context 'with root' do
      before do
        @root_page = FactoryGirl.create(:root_page) end
      let(:sub1sub1_page) { FactoryGirl.create(:sub1sub1_page, parent: FactoryGirl.create(:sub1_page, parent: @root_page)) }
      subject { get :edit, path: sub1sub1_page }
      it_behaves_like("with not found page with root") { subject { get :edit, path: not_existing_path } }
      it "returns http success" do
        response.should be_success
      end
    end
  end

  describe "GET 'add_root'" do
    subject { get :add_root }
    it "returns http success" do
      subject.should be_success
    end
  end

  describe "GET 'add'" do
    let(:root_page) { FactoryGirl.create(:root_page) }
    subject { get :add, path: root_page }
    it "returns http success" do
      subject.should be_success
    end
  end

  shared_examples_for "success create POST" do
    it { subject; assigns(:page).should be_an_instance_of(Page) }
    it { subject; assigns(:page).should_not be_a_new(Page) }
    it "should redirect to added page" do
      subject.should redirect_to(show_path(assigns(:page).path))
    end
  end
  shared_examples_for "failed create POST" do
    it "should render add template" do
      subject.should render_template('pages/add')
    end
  end

  describe "POST 'create_root'" do
    let(:correct_attr) { { :name => 'name1', :title => 'Name1', :text => 'name1 text' } }
    context "with existing root page" do
      it_behaves_like("success create POST") { subject { post :create_root, :page => correct_attr } }
      it_behaves_like("failed create POST") { subject { post :create_root, :page => {} } }
    end
  end

  describe "POST 'create'" do
    let(:correct_attr) { { :name => 'name1', :title => 'Name1', :text => 'name1 text' } }
    context "with existing root page" do
      let(:root_page) {FactoryGirl.create(:root_page)}
      it_behaves_like("success create POST") { subject { post :create, :page => correct_attr, :path => root_page.path } }
      it_behaves_like("failed create POST") { subject { post :create, :page => {}, :path => root_page.path } }
    end
  end

end
