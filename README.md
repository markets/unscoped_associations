# Unscoped Associations

[![Gem Version](https://badge.fury.io/rb/unscoped_associations.svg)](http://badge.fury.io/rb/unscoped_associations)
[![Build Status](https://travis-ci.org/markets/unscoped_associations.svg?branch=master)](https://travis-ci.org/markets/unscoped_associations)

Have you ever needed to skip the `default_scope` when fetching objects through associations methods (for some strange reasons)? Do it easily with this `Active Record` extension!

Supported associations:

- `:belongs_to`
- `:has_one`
- `:has_many`

Officially supported (tested) `Active Record` versions: 3.2, 4.0, 4.1, 4.2 and 5.0.

## Installation

Add this line to your Gemfile:

```ruby
gem 'unscoped_associations'
```

Or install the gem manually:

```ruby
gem install unscoped_associations
```

## Usage

Basic usage example:

```ruby
class User < ActiveRecord::Base
  has_many :comments
  has_many :all_comments, class_name: 'Comment', unscoped: true

  default_scope { where(active: true) }
end

class Comment < ActiveRecord::Base
  belongs_to :user, unscoped: true

  default_scope { where(public: true) }
end
```

From now on, you get:

- `@user.comments`: return all public comments
- `@user.all_comments`: return all comments skipping the default_scope
- `@comment.user`: return the user without taking account the 'active' flag

## Status

This project was originally thought and built for a Rails 3.2 application.

Rails 4 introduces some updates regarding associations. For example, since Rails 4 (AR 4 to be precise), you are able to customize associations using a scope block (overriding conditions), so you can skip the `default_scope` conditions by:

```ruby
class User < ActiveRecord::Base
  has_many :all_comments, -> { where(public: [true, false]) }, class_name: 'Comment'
end
```

Since Rails 4.1, you can also override the default conditions using the `unscope` method:

```ruby
class User < ActiveRecord::Base
  has_many :all_comments, -> { unscope(where: :public) }, class_name: 'Comment'
end
```

Anyway, you can continue using `unscoped_associations`, could be useful in certain situations, for example, if you prefer to bypass the entire `default_scope`, given a scope with multiple conditions, like:

```ruby
default_scope { where(public: true).order(:updated_at) }
```

It was also supported for Rails 4.X series and 5.0 as a migration path.

## Notes

- Under the hood, Unscoped Associations relies on the `unscoped` method (from AR). So, chaining unscoped associations with other AR query methods won't work. E.g.: `@user.all_comments.count` will load comments with the `defaul_scope` applied. In this case, `@user.all_comments.to_a.count` should work.
- Unscoped Associations doen't touch the preloading layer, so `includes`, `joins`, ... with unscoped associations, can cause `N+1` problems.

## Contributing

Any kind of fixes, both code and docs, or enhancements are really welcome!

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the tests by:

```
bundle exec rspec
bundle exec appraisal rspec # run against all supported AR versions
```

## License

Copyright (c) Marc Anguera. Unscoped Associations is released under the [MIT](LICENSE) License.
