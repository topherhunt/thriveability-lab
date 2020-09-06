# Thriveability Lab


**This project is inactive.**


If we were to reactivate it, consider these tasks next:

  - If any validation errors, the file attachment is lost and must be re-attached. Prevent this. (https://github.com/carrierwaveuploader/carrierwave#making-uploads-work-across-form-redisplays, or https://github.com/mariohmol/paperclip-keeponvalidation - this might be the easiest for now)
  - Gray tags in dashboard lists: Replace with a `label-white` class that's much more backgrounded. Make not links. Maybe more rounded.
  - Resources form: client-side validate attachment size of max 10 MB. (https://stackoverflow.com/questions/3717793/javascript-file-upload-size-validation, https://stackoverflow.com/questions/7497404/get-file-size-before-uploading)
  - Page load times improved. I’d like most pages to be under 200ms. The homepage & index pages are currently around 1000ms, which sucks.
  - Home & all object index pages query-optimized. (Loading the page should only trigger a handful of queries, and no duplicate queries with the same structure.)
  - Event target models should have an on_delete callback to clear out all notifications related to that object.
  - [1h] My User#interests method was a duplicate. Compare output to that of UserData#interests_map, and switch to the latter as long as it's acceptable. (One potential problem: it appears to include resource media types which shouldn't be included.)
  - Conversations can be liked
  - When viewing or editing a comment, go to the anchor on the conversation page for that comment (ie. jump straight to it, instead of jumping to the top of the convo)
  - Trix editor: Hide toolbar until you click in the editor
  - "Edit comment" form in-lined on conversation page using ajax
  - User can comment on a project or resource. (No intention statement needed; Projects & Resources dashboards: Consider switching the 3rd column to "Recent comments"; Comments on a project or resource are included in its ES index; Adding a comment should trigger an ES index update?)
  - Renamed Notification to EventNotification
  - Event notification tests cleaned up. (Consider moving the event notification tests out of their current context and into the controller tests, since it's always in the controller action that the relevant event is registered. Testing this is part & parcel with testing the creation and the redirect.)


And also consider these "wishlist" tasks:

  - **Comment upvoting.** Each comment can be upvoted to indicate significance. A user can only vote on an item once. Don't do downvoting yet; I'm not convinced of its value. (Reflect: What's the difference between likes and upvotes? Upvotes send a different message than likes. Not just whether people like this thing, but whether they think it's **important**. Different semantics. I also picture the upvotes being visible prominently on the list of things, as a primary score of its significance. Likes currently aren't used that way.)
  - **Nested comments**. A user can reply to a comment. When viewing the conversation, replies show up right under the comment they're replying to, and indentend slightly. (emulate Disqus or Reddit indentation style). You can collapse a comment and all its replies. (To add once we see examples of conversations that get too cluttered because no threading)
  - Notifications? A user can notify any other user(s) when they write a comment, by specifying their name in a field above the comment body.
  - **Draft conversations / comment**. A user can (auto?) save their work on a conversation or comment without making it public. They can see a list of all drafts under their user menu -> "N drafts". (This would mean the comment form must work as a standalone page and not be only viewable under the Conversation#show page.)
  - **Autosave** (implement some sort of autosave or text recovery when we see evidence that it's needed). Ideally this uses an "AutosavedStuff" model rather than piggybacking on the primary model.
  - Search page: can filter by author. When searching for stuff, you need to be able to filter your search to "created by [person]". e.g. so Annick can easily look up all the resources she's added.
  - If user provides a video URL but no image, on save, autogenerate a thumbnail for that video and store that as the image.
  - location_of_home and location_of_impact are just static strings for now. In a follow-up task, when these are entered, I should geolocate them and store a) the coordinates and b) the country, for searching later.
  - Rewrote the IWH app in Elixir/Phoenix. Assuming there's enough demand / potential traffic to justify the effort, it would be fun to rebuild the current featureset (and I think not too painful as long as we're just cloning existing features) and compare performance across the two.
  - Simplify the navbar to just: title, search, account menu. (Getting to lists of specific content types happens on the search results page. Seeing any content I'm already associated with, can happen via my user profile page which lists all content I've contributed / am connected to. Contributing new content happens via the user profile page, or when searching for a topic.)
  - Simplify and standardize test coverage. (thorough "request specs" for controller & view rendering layer; sparse judicious unit tests; minimal integration tests.)
  - Discuss: Idea: "See also" system. This is how you link resources, articles, projects, etc. The owner of a given object can add “pointers” to other objects that he or she wants to endorse as relevant to this object. Pointers can be backtraced but are one-directional, so the referent / target doesn’t need to approve the creation of this pointer. You can add as many pointers as you want, but when we implement a scoring or recommendation system built on this, we should consider that pointers will be extremely gameable.
  - Viewings should be its own table. (Resources currently has a `viewings` integer field, but this is very susceptible to manipulation e.g. if a person refreshes the page 100 times in a row. A more sustainable answer would be to track each viewing as a separate record, and limit it to one per user per date. Fields: id, target_type, target_id, viewer_id, date.  Only one per person per thing per date. This will prevent spamming.)
  - Title bar should indicate the current page, eg. "Enacting Carbon Fee & Dividend | Integral Climate"
  - Collapse GetInvolvedFlag, LikeFlag, StayInformedFlag to just a "flag" model with a "type" column. (May need to split them out again later, but for now they're identically structured so it will make much more sense to simplify. Actually - consider what effect this will have on the code first. I don't know that this will simplify anything, if anything it might clutter up the models with longer customized scoped associations. ... I'd prefer fewer models for now. It's chaos, and they're all in the same namespace and it's ugly.)
  - The navbar feels cluttered with the search bar and the People, Projects, Conversations, and Resources links. Work with a designer to come up with a simpler approach that still meets our usage needs: 1) user can easily search for any content on the site, 2) user can easily contribute content, and understand what content type is the best match for their contribution.
  - Filter search results by location / region (once we geolocate locations). "Show results X miles / km from [arbitrary location]"
  - Update the users list to have more info like the homepage cards. Each user card should show the interest tags. Also add # of likes and follows (icons, with tooltips to explain what they mean)




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
