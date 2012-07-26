require 'spec_helper'

describe PageParser do
  let(:bold_text) { "**[string]**" }
  let(:slash_text) { '\\[string]\\' }
  let(:link_text) { '((name1/name2/name3 [string]))' }

  describe "::to_html" do
    it { PageParser.to_html(bold_text).should be == "<b>[string]</b>" }
    it { PageParser.to_html(slash_text).should be == "<i>[string]</i>" }
    it { PageParser.to_html(link_text).should be == '<a href="/name1/name2/name3">[string]</a>' }
  end
end
