class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  enum status: { pending: 0, confirmed: 1 }

  def confirm_friend
    Friendship.create(user_id: friend_id, friend_id: user_id, status: 'confirmed')
  end

  after_destroy do |f|
    friendship = Friendship.find_by(user_id: f.friend_id, friend_id: f.user_id)
    friendship&.destroy
  end
end
