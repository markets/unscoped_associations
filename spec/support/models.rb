class User < ActiveRecord::Base
  has_many :comments do
    def today
      where('created_at <= ?', Time.now.end_of_day)
    end
  end

  has_many :unscoped_comments, class_name: 'Comment', unscoped: true do
    def today
      where('created_at <= ?', Time.now.end_of_day)
    end
  end

  has_one  :last_comment, class_name: 'Comment', order: 'created_at DESC'
  has_one  :unscoped_last_comment, class_name: 'Comment', order: 'created_at DESC', unscoped: true

  default_scope { where(active: true) }
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :scoped_user, class_name: 'User', foreign_key: 'user_id', unscoped: false
  belongs_to :unscoped_user, class_name: 'User', foreign_key: 'user_id', unscoped: true

  default_scope { where(public: true) }
end
