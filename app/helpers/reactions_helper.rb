# frozen_string_literal: true

module ReactionsHelper
  def reaction_form_id_name(reactionable)
    comment?(reactionable) ? "comment_reaction_form#{reactionable.id}" : "complete_post_reaction_form#{reactionable.id}"
  end

  def reaction_count_id_name(reactionable)
    comment?(reactionable) ? "comment_reaction_count#{reactionable.id}" : "complete_post_reaction_count#{reactionable.id}"
  end

  def reactionable_path(reaction)
    reaction.comment? ? comment_reactions_path(reaction.reactionable) : complete_post_reactions_path(reaction.reactionable)
  end

  private

  def comment?(reactionable)
    reactionable.instance_of?(Comment)
  end
end
