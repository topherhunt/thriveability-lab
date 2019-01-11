module AuthHelper
  def login_url
    # This redirect to topherhunt.auth0.com/authorize is invisibly defined when
    # the OmniAuth provider is defined (see config/initializers/omniauth.rb)
    "/auth/auth0"
  end
end
