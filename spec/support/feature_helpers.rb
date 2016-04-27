def log_in(user)
  visit root_path
  click_link "Log in"
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  click_button "Log in"
end

def log_out
  visit root_path
  page.should have_link("Log out")
  click_link "Log out"
end

def expect_attributes(object, hash)
  hash.each do |k, v|
    object.send(k).should eq v
  end
end

def fill_fields(hash)
  hash.each do |k, v|
    fill_in k, with: v
  end
end

def page!
  save_and_open_page
end
