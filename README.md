# Thriveability Lab


## Code principles

- Simpler is better. Resist overcomplexifying. Prefer duplication over imperfect abstraction.
- HTML classes for CSS, JS, and test selection should be namespaced and kept strictly separate. For example, any class used for selecting elements in tests should start with `test-`.


## Areas of the code to know about


### Auth0

I abandoned Devise in favor of Auth0 managed user auth. See AuthController. Also see https://github.com/topherhunt/cheatsheets/blob/master/rails/auth0.md. Features include:

- Database login via UN & PW
- Google and FB login
- Force login for admins (see auth.rake)


### ElasticSearch

We use ElasticSearch for a simple full-text search index. I tried `elasticsearch-rails` but found I needed to customize it a lot, so I ditched it and wrote my own wrapper that directly makes calls using the low-level driver. See `ElasticsearchWrapper`, `ElasticsearchIndexHelper`, and `Searchable`.

- In development, run `elasticsearch` or indexing & searching will be disabled. (`brew install elasticsearch`)
- In production, we use the Bonsai Heroku add-on, but any ES server will work as long as we provide the full URL in `ENV['ELASTICSEARCH_URL']`.
- To do a full reindex: `ElasticsearchIndexHelper.new.delete_and_rebuild_index!`


### Paperclip

Paperclip is way deprecated and slowly crumbling. I tried moving to ActiveStorage, then realized that (as of Rails 5.2) AS is an immature and intolerably unperformant solution. Ideally I'd migrate to CarrierWave, but left Paperclip in place for now to reduce my yak-shave factor. Who knows, Paperclip might serve well enough until more major architectural changes make it irrelevant.


### Tests

Controller tests should cover each endpoint, each important scenario, and each important outcome / side effect.

Integration tests should:
- always  start at the root path. Avoid other `navigate_to` calls. This gives nominal coverage of navigation links etc.
- test the happy path for each form, filling out every available field and checking that each was persisted properly. This helps ensure that controller permitted params are correctly mapped to the form fields we expect to be able to fill in.
- cover any key JS logic that we have no other way of covering
- be otherwise kept extremely short and minimal.

Unit tests should be added as needed to cover complex logic e.g. in Service classes.


## Deploying

Things to check when deploying to a new or majorly changed environment:

- Auth0 login with FB & Google works; logout works
  (see https://github.com/topherhunt/cheatsheets/blob/master/rails/auth0.md)
- ElasticSearch auto-indexing of `Searchable` models works; searching works


## Heroku

Tips for managing a Heroku deploy:

- The online dashboard will indicate the last deploy time & git commit id
- Tail the production logs: `heroku logs --tail | grep "app\["`

