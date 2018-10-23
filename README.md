# Thrivability Lab

## Code principles

- Simpler is better. Resist overcomplexifying. Prefer duplication over imperfect abstraction.
- HTML classes for CSS, JS, and test selection should be namespaced and kept strictly separate. For example, any class used for selecting elements in tests should start with `test-`.

## Todo

- App renders times in terms of US EST; make this sensitive to where the user is

## Social media login

Dashboards for managing settings:

- https://console.developers.google.com/apis/credentials?project=integral-climate
- https://developers.facebook.com/apps/1772130993029813/settings/
- [LinkedIn: Todo]

## Search

- Full-text search uses the Bonsai ElasticSearch add-on.
- We use [`elasticsearch-model`](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model) for Rails integration.
- In development, run `elasticsearch` to allow indexing and querying.

Sample commands:

- `Project.__elasticsearch__.client.cluster.health`
- `Project.__elasticsearch__.import(force: true)`
- `Project.__elasticsearch__.search('psychology')`

Reindex all content, e.g. after changing the indexed schema:
```
[Project, Conversation, Resource, User].each { |c| c.__elasticsearch__.import(force: true) }
```

## Tests

I'm moving away from "full-coverage" integration tests. My current testing philosophy is:

- Thorough coverage for each controller endpoint
- Judicious Unit tests as-needed to cover complex logic, likely regressions, etc.
- Integration tests:
  - `test/integration/regression/` - bare-minimum coverage of client-side functionality that can't be covered in controller tests (e.g. complex forms and JS)
  - `test/integration/tdd/` - a place to write high-level specs to drive out new features. Most of these tests are temporary and will be replaced by controller and regression integration tests in the future.
