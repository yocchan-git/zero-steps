class Comment < ApplicationRecord
  mentionable_as :content

  has_many :reactions, as: :reactionable, dependent: :destroy
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }

  def goal?
    commentable_type == 'Goal'
  end

  def after_save_mention(new_mentions)
    # メンションされた後のメソッドだが、何もしない
  end
end
