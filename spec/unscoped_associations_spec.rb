require 'spec_helper'

describe UnscopedAssociations do
  context 'unscoped association omits default_scope' do
    it 'belongs_to' do
      user = User.create(active: false)
      comment = Comment.create(user_id: user.id)

      expect(comment.unscoped_user).to eq(user)
    end

    it 'has_many' do
      user = User.create
      comment = Comment.create(user_id: user.id, public: false)

      expect(user.unscoped_comments).to be_present
    end

    it 'has_one' do
      user = User.create
      comment = Comment.create(user_id: user.id, public: false)

      expect(user.unscoped_last_comment).to be_present
    end
  end

  context 'no unscoped association takes default_scope' do
    it 'belongs_to' do
      user = User.create(active: false)
      comment = Comment.create(user_id: user.id)

      expect(comment.user).to be_nil
      expect(comment.scoped_user).to be_nil
    end

    it 'has_many' do
      user = User.create
      comment = Comment.create(user_id: user.id, public: false)

      expect(user.comments).to be_empty
    end

    it 'has_one' do
      user = User.create
      comment = Comment.create(user_id: user.id, public: false)

      expect(user.last_comment).to be_nil
    end
  end
end