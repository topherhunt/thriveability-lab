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

## Deployment

Deployed on Heroku at

Errors are collected in Rollbar: https://rollbar.com/instance/uuid?uuid=a1a4cc32-c538-4aa2-a2d0-f2dfef24048e
