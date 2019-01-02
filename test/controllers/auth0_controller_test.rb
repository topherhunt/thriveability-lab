require "test_helper"

# I almost never use controller specs. These are only here so I have an easy
# template to copy from if I need to test some advanced controller logic.

class Auth0ControllerTest < ActionController::TestCase
  tests Auth0Controller

  context "#login_callback" do
    # TODO: This test doesn't cover Omniauth's logic, which uses the provided
    # Auth0 token to look up and provide the info on the logged-in user.
    it "logs in the user found or created by the service" do
      user = create :user
      Services::FindOrCreateUserFromAuth.stubs(call: user)

      get :login_callback

      assert_equals user.id, session[:user_id]
      assert_redirected_to root_path
    end
  end

  context "#logout" do
    it "logs out a logged-in user" do
      user = create :user
      sign_in user
      assert_equals user.id, session[:user_id]

      get :logout

      assert_equals nil, session[:user_id]
      assert_redirected_to root_path
    end
    # Behavior is identical if you're not logged in for some reason.
  end

  context "#force_login" do
    it "works if you give a valid password" do
      user = create :user

      get :force_login, user_id: user.id, password: ENV['FORCE_LOGIN_PASSWORD']

      assert_equals user.id, session[:user_id]
      assert_redirected_to root_path
    end

    it "rejects if you give an invalid password" do
      user = create :user

      assert_raise(RuntimeError) do
        get :force_login, user_id: user.id, password: ENV['FORCE_LOGIN_PASSWORD'] + 'z'
      end
    end
  end
end
