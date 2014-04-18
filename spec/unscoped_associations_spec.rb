require 'spec_helper'

describe UnscopedAssociations do
  let(:user) { User.create active: false }
  let(:comment) { Comment.create user_id: user.id, public: false }
  let(:user_vote) { user.votes.create public: false }
  let(:comment_vote) { comment.votes.create }

  context 'a belongs to association' do
    subject { comment }

    context 'scoped' do
      its(:user) { should be_nil }
      its(:scoped_user) { should be_nil }
    end

    context 'unscoped' do
      its(:unscoped_user) { should eq user }
    end
  end

  context 'a has one association' do
    subject { user }

    context 'scoped' do
      its(:last_comment) { should be_nil }
    end

    context 'unscoped' do
      its(:unscoped_last_comment) { should eq comment }
    end
  end

  context 'a has many association' do
    subject { user }

    context 'scoped' do
      its(:comments) { should be_empty }

      context 'with an extension' do
        its('comments.today') { should be_empty }
      end
    end

    context 'unscoped' do
      its(:unscoped_comments) { should eq [comment] }

      context 'with an extension' do
        # Extended methods take the default_scope
        its('unscoped_comments.today') { should be_empty }
        # Ideally, it should skip the default_scope
        # its('unscoped_comments.today') { should eq [comment] }
      end
    end
  end

  context 'has_many with unscoped polymorphic' do
    subject { user }

    context 'unscoped_votable' do
      its(:votes) { should eq [user_vote] }
    end
  end

  context 'belongs_to with unscoped polymorphic' do
    subject { comment_vote }

    context 'unscoped_votable' do
      its(:votable) { should eq comment }
    end
  end
end
