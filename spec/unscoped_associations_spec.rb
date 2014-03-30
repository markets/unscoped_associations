require 'spec_helper'

describe UnscopedAssociations do
  it 'belongs_to with unscoped option should skip default_scope' do
    user = User.create(:active => false)
    comment = Comment.create(:user_id => user.id)

    expect(comment.user).to eq(user)
  end
end