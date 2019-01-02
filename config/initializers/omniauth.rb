Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0, # This invisibly defines a redirect: /auth/oauth0 => Auth0's login page
    ENV["AUTH0_CLIENT_ID"],
    ENV["AUTH0_CLIENT_SECRET"],
    ENV["AUTH0_DOMAIN"],
    callback_path: "/auth/oauth2/login_callback",
    # OpenID scopes - see https://auth0.com/docs/scopes/current/oidc-scopes
    authorize_params: {scope: "openid profile email"}
  )
end
