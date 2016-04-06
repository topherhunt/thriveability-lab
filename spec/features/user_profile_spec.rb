require 'rails_helper'
require 'support/feature_helpers'

describe "User profile" do
  before do
    @user = create :user
    log_in @user
  end

  describe "Edit page" do
    example "User fills in their profile" do
      click_on "My Profile"
      click_on "Edit"
      expect(page).to have_content "Edit my profile"

      # Basic profile info
      fill_fields(
        "user[first_name]" => "Elmer",
        "user[last_name]" => "Fudd",
        "user[skill_list]" => "knitting, hunting",
        "user[passion_list]" => "cartoons, wacky wabbits",
        "user[trait_list]" => "diligent, stealthy, tireless, patient",
        "user[dream_of_future_where]" => "all men are created equal")
      attach_file "user[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
      expect(page).to have_selector ".dream-of-future-exemplars"

      click_button "Save"
      expect(page).to have_content "Your profile has been updated."
      expect_attributes(@user.reload,
        first_name: "Elmer",
        last_name: "Fudd",
        image_file_name: "elmerfudd.jpg",
        skill_list: ["knitting", "hunting"],
        passion_list: ["cartoons", "wacky wabbits"],
        trait_list: ["diligent", "stealthy", "tireless", "patient"],
        dream_of_future_where: "all men are created equal")

      # Add one or more resources
      expect(page).to have_content "Learn more about my work"
      expect(page).to have_selector ".new-resource", count: 1
      fill_fields(
        "resource[title]" => "My grant proposal",
        "resource[description]" => "Interesting summary of blah",
        "resource[url]" => "http://abc.def")
      attach_file "resource[attachment]", with: "#{Rails.root}/public/test/leaders.pdf"
      check_box "resource[ownership_affirmed]"
      expect(@user.created_resources.count).to eq 0
      click_button "Save this resource"
      expect(page).to have_content "Resource saved!"
      expect(@user.created_resources.count).to eq 1
      expect_attributes(@user.created_resources.first,
        title: "My grant proposal",
        description: "Interesting summary of blah",
        url: "http://abc.def",
        attachment_file_name: "leaders.pdf")

      # Can add more resources if we want to
      page.find(".js-add-resource").click
      expect(page).to have_selector ".new-resource", count: 2
      page.find(".new-resource").second.find(".js-remove-resource").click
      expect(page).to have_selector ".new-resource", count: 1

      click_on "Back to my profile page"
      expect(page).to have_content "My Profile"
    end
  end
end
