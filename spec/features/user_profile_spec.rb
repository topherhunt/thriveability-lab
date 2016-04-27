require 'rails_helper'
require 'support/feature_helpers'

describe "User profile" do
  before do
    @user = create(:user)
  end

  specify "User can fill in profile info" do
    log_in @user
    click_on "My Profile"
    click_on "Edit"
    current_path.should eq edit_user_path(@user)
    fill_fields(
      "user[first_name]" => "Elmer",
      "user[last_name]" => "Fudd",
      "user[skill_list]" => "knitting, hunting",
      "user[passion_list]" => "cartoons, wacky wabbits",
      "user[trait_list]" => "diligent, stealthy, tireless, patient",
      "user[dream_of_future_where]" => "all men are created equal")
    attach_file "user[image]", "#{Rails.root}/public/test/elmerfudd.jpg"
    # page.should have_selector ".dream-of-future-exemplars"
    click_button "Save"
    current_path.should eq user_path(@user)
    page.should have_content "Your profile has been updated."
    expect_attributes(@user.reload,
      first_name: "Elmer",
      last_name: "Fudd",
      image_file_name: "elmerfudd.jpg",
      skill_list: ["knitting", "hunting"],
      passion_list: ["cartoons", "wacky wabbits"],
      trait_list: ["diligent", "stealthy", "tireless", "patient"],
      dream_of_future_where: "all men are created equal")
  end
end
