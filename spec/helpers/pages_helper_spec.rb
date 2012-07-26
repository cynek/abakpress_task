require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PagesHelper. For example:
#
# describe PagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PagesHelper do
  describe "#title" do
    it { helper.title.should be == 'Page' }
    it { assign(:title, 't'); helper.title.should be == 't' }
  end
end
