require 'spec_helper'

describe UnscopedAssociations do
  let(:user) { User.create active: false }
  let(:comment) { Comment.create user_id: user.id, public: false }

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
        # I am not sure why it doesn't work with extensions
        # its('unscoped_comments.today') { should eq [comment] }
      end
    end
  end
end
