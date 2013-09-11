Unscoped Associations
=====================
Want to skip the `default_scope` when you get objects through associations (for some strange reasons)? Do it easily with this lib. Supported associations:
* `:belongs_to`
* `:has_one`
* `:has_many`

## Installation
Add this line to your Gemfile:

```ruby
gem 'unscoped_associations'
```

Or install the gem:

```ruby
gem install unscoped_associations
```

## Usage
Basic usage example:

```ruby
class User < ActiveRecord::Base
  has_many :comments # or , unscoped: false
  has_many :all_comments, class_name: 'Comment', unscoped: true
  has_one  :last_comment, class_name: 'Comment', order: 'created_at DESC', unscoped: true

  default_scope where( active: true )
end

class Comment < ActiveRecord::Base
  belongs_to :user, unscoped: true

  default_scope where( public: true )
end

@user.comments # => return public comments
@user.all_comments # => return all comments skipping default_scope
@user.last_comment # => return last comment skipping default_scope
@topic.user # => return user w/o taking account 'active' flag

```

## Status
Tested on Rails 3.x series and Rails 4.0.0. Originally thought and built for Rails 3, Rails 4 supported.

NOTE: Rails 4 introduces some updates (and more planned for upcoming releases) related to this part. For example, in Rails 4, you are able to customize associations using a scope block, so you can skip `default_scope`:

```ruby
class User < ActiveRecord::Base
  has_many :all_comments, -> { where public: [true, flase] }, class_name: 'Comment'
end
```

Anyway, you can use `unscoped` option, if you prefer.

## Contributing
Ideas, fixes, improvements or any comment are welcome!

## License
Copyright (c) 2013 Marc Anguera. Unscoped Associations is released under the [MIT](http://opensource.org/licenses/MIT) License.