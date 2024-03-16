class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  def reaction_form_id_name
    comment? ? "comment_reaction_form#{reactionable.id}" : "complete_post_reaction_form#{reactionable.id}"
  end

  def reaction_count_id_name
    comment? ? "comment_reaction_count#{reactionable.id}" : "complete_post_reaction_count#{reactionable.id}"
  end

  def comment?
    reactionable_type == 'Comment'
  end
end
