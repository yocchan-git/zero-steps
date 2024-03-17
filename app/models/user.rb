# frozen_string_literal: true

class User < ApplicationRecord
  has_many :goals, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :complete_posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :timelines, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :uid, presence: true
  validates :name, presence: true

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
