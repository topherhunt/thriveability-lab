require "test_helper"

class AuthControllerTest < ActionController::TestCase
  tests AuthController

  context "#auth0_callback" do
    # TODO: This test doesn't cover Omniauth's logic, which uses the provided
    # Auth0 token to look up and provide the info on the logged-in user.
    it "logs in the user found or created by the service" do
      user = create :user
      FindOrCreateUserFromAuth.stubs(call: user)

      get :auth0_callback

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

      assert_nil session[:user_id]
      assert_redirected_to /#{ENV.fetch("AUTH0_DOMAIN")}/
    end
  end

  context "#force_login" do
    it "works if you give a valid password" do
      user = create :user

      get :force_login, params: {user_id: user.id, password: ENV['FORCE_LOGIN_PASSWORD']}

      assert_equals user.id, session[:user_id]
      assert_redirected_to root_path
    end

    it "rejects if you give an invalid password" do
      user = create :user

      assert_raise(RuntimeError) do
        get :force_login, params: {user_id: user.id, password: ENV['FORCE_LOGIN_PASSWORD'] + 'z'}
      end
    end
  end
end
