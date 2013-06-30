Unscoped Associations
=====================
It may be that you've ever needed to skip `default_scope` pulling objects via associations (for some strange reasons).
Do it easily with this lib. Supported associations:
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
Tested on Rails 3.x series. In Rails 4 you are able to customize data retrieving via a scope block, so you can skip `default_scope` using a block.


## Contributing
Ideas, fixes, improvements or any comment are welcome!


## License
Copyright (c) 2013 Marc Anguera. Unscoped Associations is released under the [MIT](http://opensource.org/licenses/MIT) License.