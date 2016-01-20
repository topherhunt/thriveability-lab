# Integral Climate Action site

## What's set up

- Bootstrap styling
- Devise for standard user auth
- Figaro is used; all sensitive vars should be kept in application.yml
- Secret token is dynamically generated each time the server starts up
- Security is 80% loose on this site. Users can register and use the site without confirming their account (via email) for 24 hours, then are asked to confirm account before continuing.
- User stays signed in for 24 hours by default, and can check "Remember me" on signin to stay signed in for 1 month.
- Rspec simple test suite

## Todo

- App renders times in terms of US EST; make this sensitive to where the user is
- Mandrill configured for mailings. Set up account & key for this

### Heroku prep

- Add gem `rails_12factor` in group `:production`
- `bundle install`
- `rake rails:update:bin`
- set `config.force_ssl = true` in production
- Ensure Glyphicon fonts compile correctly in production:

```
config.assets.precompile += %w( .woff .eot .svg .ttf )
config.assets.compile = true (from false)
```

- `heroku create`
- `git push heroku master`
- `heroku run rake db:migrate`
- `rake figaro:heroku`
- `heroku open` and test!
