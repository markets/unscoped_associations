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

  if ActiveRecord::VERSION::MAJOR >= 4
    has_one  :last_comment, -> { order('created_at DESC') }, class_name: 'Comment'
    has_one  :unscoped_last_comment, -> { order('created_at DESC') }, class_name: 'Comment', unscoped: true
  else
    has_one  :last_comment, class_name: 'Comment', order: ('created_at DESC')
    has_one  :unscoped_last_comment, class_name: 'Comment', unscoped: true, order: ('created_at DESC')
  end

  has_many :votes, as: :votable, unscoped: true

  default_scope { where(active: true) }
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :scoped_user, class_name: 'User', foreign_key: 'user_id', unscoped: false
  belongs_to :unscoped_user, class_name: 'User', foreign_key: 'user_id', unscoped: true
  has_many :votes, as: :votable

  default_scope { where(public: true) }
end

class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, unscoped: true
  # @note dirty hack for creating through-association
  belongs_to :comment, foreign_key: 'votable_id', class_name: 'Comment'
  has_one :bool_user, through: :comment, unscoped: true, source: :user
  has_one :str_user, through: :comment, unscoped: 'comment', source: :user
  has_one :sym_user, through: :comment, unscoped: :comment, source: :user
  has_one :class_user, through: :comment, unscoped: Comment, source: :user

  default_scope { where(public: true) }
end
