class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Friendship
  has_many :friendships, -> { where(status: 'confirmed') }
  has_many :friends, through: :friendships

  has_many :pending_friendships, -> { where(status: 'pending') },
           class_name: 'Friendship', foreign_key: 'user_id'

  has_many :confirmed_friendships, -> { where(status: 'pending') },
           class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :pending_friends, through: :pending_friendships, source: :friend

  def friend?(user)
    friendship = Friendship.find_by(user_id: user.id, friend_id: id, status: 'confirmed') ||
                 Friendship.find_by(user_id: id, friend_id: user.id, status: 'confirmed')
    true unless friendship.nil?
  end

  def pending_friendship(user)
    friend_requests.find { |friendship| friendship if friendship.user == user }
  end

  def pending_friendship?(user)
    !pending_friendship(user).nil?
  end

  def friend_requests
    Friendship.where(friend_id: id, confirmed: false)
  end

  def confirm_friend(user)
    friendship = friend_requests.find { |friend| friend.user == user }
    friendship.confirmed = true
    friendship.save
  end
end
