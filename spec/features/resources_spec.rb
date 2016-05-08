require 'rails_helper'
require 'support/feature_helpers'

describe "Resources" do
  before do
    @user = create(:user)
  end

  specify "user can add resources from their profile page" do
    log_in @user
    visit user_path(@user)
    page.should have_selector ".resource", count: 0
    click_on "Add a resource"
    fill_fields(
      "resource[title]" => "My grant proposal",
      "resource[description]" => "Interesting summary of blah",
      "resource[url]" => "http://abc.def")
    attach_file "resource[attachment]", "#{Rails.root}/public/test/leaders.pdf"
    check "resource[ownership_affirmed]"
    click_button "Save"
    current_path.should eq user_path(@user)
    page.should have_selector ".resource", count: 1
    page.should have_content "My grant proposal"
    @user.created_resources.count.should eq 1
    expect_attributes(@user.created_resources.first,
      title: "My grant proposal",
      description: "Interesting summary of blah",
      url: "http://abc.def",
      attachment_file_name: "leaders.pdf")
  end
end
