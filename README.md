# Thriveability Lab


## Code principles

- Simpler is better. Resist overcomplexifying. Prefer duplication over imperfect abstraction.
- HTML classes for CSS, JS, and test selection should be namespaced and kept strictly separate. For example, any class used for selecting elements in tests should start with `test-`.


## Areas of the code to know about


### Auth0

I abandoned Devise in favor of Auth0 managed user auth. See AuthController. Also see https://github.com/topherhunt/cheatsheets/blob/master/rails/auth0.md. Features include:

- Google and FB login
- Force login for admins (see auth.rake)


### ElasticSearch

We use ElasticSearch for a simple full-text search index. I tried `elasticsearch-rails` but found I needed to customize it a lot, so I ditched it and wrote my own wrapper that directly makes calls using the low-level driver. See `ElasticsearchWrapper`, `ElasticsearchIndexHelper`, and `Searchable`.

- In development, run `elasticsearch` or indexing & searching will be disabled. (`brew install elasticsearch`)
- In production, we use the Bonsai Heroku add-on, but any ES server will work as long as we provide the full URL in `ENV['ELASTICSEARCH_URL']`.
- To do a full reindex: `ElasticsearchIndexHelper.new.delete_and_rebuild_index!`

Errors:

- Transport exceptions usually mean that the ES service isn’t running / isn’t reachable.


### Tests

I'm moving away from "full-coverage" integration tests. My current testing philosophy is:

- Thorough coverage for each controller endpoint, each branch
- Judicious Unit tests as-needed to cover complex logic, likely regressions, etc.
- Integration tests:
  - `test/integration/regression/` - bare-minimum coverage of client-side functionality that can't be covered in controller tests (e.g. complex forms and JS)
  - `test/integration/tdd/` - a place to write high-level specs to drive out new features. Most of these tests are temporary and will be replaced by controller and regression integration tests in the future.


## Deploying

Things to check when deploying to a new or majorly changed environment:

- Auth0 login with FB & Google works; logout works
  (see https://github.com/topherhunt/cheatsheets/blob/master/rails/auth0.md)
- ElasticSearch auto-indexing of `Searchable` models works; searching works


## Heroku

Tips for managing a Heroku deploy:

- The online dashboard will indicate the last deploy time & git commit id
- Tail the production logs: `heroku logs --tail | grep "app\["`

