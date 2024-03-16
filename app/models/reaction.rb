class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  def reactionable_id_name
    comment? ? "comment_reaction_form#{reactionable.id}" : "complete_post_reaction_form#{reactionable.id}"
  end

  def comment?
    reactionable_type == 'Comment'
  end
end
