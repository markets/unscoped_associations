require 'spec_helper'

describe UnscopedAssociations do
  let!(:user) { User.create(active: false) }
  let!(:comment) { Comment.create(unscoped_user: user, public: false) }
  let!(:user_vote) { Vote.create(votable: user, public: false) }
  let!(:comment_vote) { Vote.create(votable: comment) }

  context 'a belongs to association' do
    it 'scoped' do
      expect(comment.user).to be_nil
      expect(comment.scoped_user).to be_nil
    end

    it 'unscoped' do
      expect(comment.unscoped_user).to eq(user)
    end

    it 'unscoped polymorphic' do
      expect(comment_vote.votable).to eq(comment)
    end
  end

  context 'a has one association' do
    it 'scoped' do
      expect(user.last_comment).to be_nil
    end

    it 'unscoped' do
      expect(user.unscoped_last_comment).to eq(comment)
    end
  end

  context 'a has many association' do
    it 'scoped' do
      expect(user.comments).to be_empty
    end

    it 'scoped with an extension' do
      expect(user.comments.today).to be_empty
    end

    it 'unscoped' do
      expect(user.unscoped_comments).to eq([comment])
    end

    it 'unscoped accepts force_reload' do
      comments_count = user.unscoped_comments.to_a.count
      Comment.create(unscoped_user: user, public: false)
      expect(user.unscoped_comments(true).to_a.count).to eq(comments_count + 1)
    end

    it 'unscoped with an extension' do
      # Extended methods take the default_scope
      expect(user.unscoped_comments.today).to be_empty
      # Ideally, it should skip the default_scope
      # expect(user.unscoped_comments.today).to eq([comment])
    end

    it 'unscoped polymorphic' do
      expect(user.votes).to eq([user_vote])
    end
  end
end
