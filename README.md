Unscoped Associations
=====================
It may be that you've ever needed to skip default_scope pulling objects via associations (for some strange reasons).
Do it easily with this lib (available: :belongs_to, :has_many).

## Installation
Add this line to you Gemfile:

```ruby
gem 'invisible_captcha', git: 'git@github.com:markets/unscoped_associations.git'
```

## Usage
ActiveRecord:

```ruby
class User < ActiveRecord::Base

  has_many :comments # or , unscoped: false
  has_many :all_comments, unscoped: true

end

class Comment < ActiveRecord::Base

  belongs_to :user

  default_scope where: { public: true }

end

@user.comments # => return public comments
@user.all_comments # => return all comments skipping default_scope

```

## Todo
A lot of stuff.

## License
Copyright (c) 2013 Marc Anguera. Unscoped Associations is released under the [MIT](http://opensource.org/licenses/MIT) License.