# frozen_string_literal: true

class User < ApplicationRecord
  has_many :goals, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :complete_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :active_friendships, class_name: 'Friendship',
                                foreign_key: 'follower_id',
                                dependent: :destroy,
                                inverse_of: :follower
  has_many :passive_friendships, class_name: 'Friendship',
                                 foreign_key: 'followed_id',
                                 dependent: :destroy,
                                 inverse_of: :followed
  has_many :following, through: :active_friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower

  validates :uid, presence: true
  validates :name, presence: true

  scope :active, -> { where(is_hidden: false) }

  def self.fetch_multiple(user:, is_only_follows: false, page_count: nil)
    user_followings_or_self = is_only_follows ? user.following : self
    user_followings_or_self.active.preload(:goals, :tasks, :comments).order(created_at: :desc).page(page_count)
  end

  def self.auth_discord(auth)
    is_new_user = false
    user = User.find_or_create_by(uid: auth.uid) do |new_user|
      new_user.update!(
        uid: auth.uid,
        name: auth.info.name,
        image: auth.info.image
      )
      is_new_user = true
    end

    { user:, is_new_user: }
  end

  def follow(target_user)
    following << target_user unless self == target_user
  end

  def unfollow(target_user)
    following.delete(target_user)
  end

  def following?(target_user)
    following.include?(target_user)
  end
end
