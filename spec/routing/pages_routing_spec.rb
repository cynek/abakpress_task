require 'spec_helper'

describe "routes for Pages" do
  it { get('/').should route_to("pages#show") }
  it { get('/add').should route_to("pages#add_root") }
  it { post('/').should route_to("pages#create_root") }
  it { get('/name1/name2/name3').should route_to("pages#show", :path => "name1/name2/name3") }
  it { get('/name1/name2/name3/edit').should route_to("pages#edit", :path => "name1/name2/name3") }
  it { get('/name1/name2/name3/add').should route_to("pages#add", :path => "name1/name2/name3") }
  it { post('/name1/name2/name3').should route_to("pages#create", :path => "name1/name2/name3") }
  it { put('/name1/name2/name3').should route_to("pages#update", :path => "name1/name2/name3") }
end
