# frozen_string_literal: true

module ReactionsHelper
  def reaction_form_id_name(reactionable, content_type)
    case content_type
    when :comment
      "comment_reaction_form#{reactionable.id}"
    when :complete_post
      "complete_post_reaction_form#{reactionable.id}"
    end
  end

  def reaction_count_id_name(reactionable, content_type)
    case content_type
    when :comment
      "comment_reaction_count#{reactionable.id}"
    when :complete_post
      "complete_post_reaction_count#{reactionable.id}"
    end
  end

  # TODO: decoratorメソッドに移動させる
  def reactionable_uri(reaction)
    reaction.comment? ? comment_reactions_path(reaction.reactionable) : complete_post_reactions_path(reaction.reactionable)
  end
end
