module ReactionsHelper
  def reactionable_id_name(reactionable, content_type)
    case content_type
    when :comment
      "comment_reaction_form#{reactionable.id}"
    when :complete_post
      "complete_post_reaction_form#{reactionable.id}"
    end
  end
end
