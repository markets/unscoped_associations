require 'spec_helper'

describe UnscopedAssociations do
  describe '(without through association)' do
    let!(:user) { User.create(active: false) }
    let!(:comment) { Comment.create(user_id: user.id, public: false) }
    let!(:user_vote) { user.votes.create(public: false) }
    let!(:comment_vote) { comment.votes.create }

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

  describe '(with through association)' do
    let!(:user) { User.create(active: true) }
    let!(:comment) { Comment.create(user_id: user.id, public: false) }
    let!(:comment_vote) { comment.votes.create(public: true) }

    context 'a through association' do
      it 'have unscoped option eql boolean' do
        expect(comment_vote.bool_user).to be_nil
      end

      it 'have unscoped option eql Symbol' do
        expect(comment_vote.sym_user).to eql(user)
      end

      it 'have unscoped option eql String' do
        expect(comment_vote.str_user).to eql(user)
      end

      it 'have unscoped option eql Class' do
        expect(comment_vote.class_user).to eql(user)
      end
    end
  end

end
