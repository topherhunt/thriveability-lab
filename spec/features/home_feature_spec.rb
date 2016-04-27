require 'rails_helper'
require 'support/feature_helpers'

describe "Static pages" do
  specify "home page loads correctly" do
    visit root_path
    page.should have_content "Integral Climate"
    page.should have_content "Recent users"
    page.should have_content "Active projects"
  end

  specify "about page loads correctly" do
    visit root_path
    click_on "About"
    page.should have_content "About Integral Climate"
  end

  specify "#throwup raises an error for testing" do
    expect{ visit "/throwup" }.to raise_error
  end
end
