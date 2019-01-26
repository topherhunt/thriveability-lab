# Thriveability Lab


## Purpose

A hub for Integrally-oriented activists, leaders, and change-makers to share what they're working on, share useful resources, take inspiration from each other, and discuss their journeys.


## Code principles

- Simpler is better. Resist overcomplexifying. Prefer duplication over imperfect abstraction.
- HTML classes for CSS, JS, and test selection should be namespaced and kept strictly separate. For example, any class used for selecting elements in tests should start with `test-`.

Testing philosophy:

- Thorough controller test coverage (every endpoint, every logic branch).
- Integration tests covering every form, every field. Otherwise keep it minimal.
- Judicious unit tests for any complex logic, as needed.
- See https://github.com/topherhunt/cheatsheets/blob/master/patterns/testing.md for more detail


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


## Deploying

We deploy to Heroku.

Tips for managing a Heroku deploy:

- The online dashboard will indicate the last deploy time & git commit id
- Tail the production logs: `heroku logs --tail | grep "app\["`

Things to check when deploying to a new or majorly changed environment:

- Auth0 login with FB & Google works; logout works
  (see https://github.com/topherhunt/cheatsheets/blob/master/rails/auth0.md)
- ElasticSearch auto-indexing of `Searchable` models works; searching works
