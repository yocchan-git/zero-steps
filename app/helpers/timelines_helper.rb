# frozen_string_literal: true

module TimelinesHelper
  def group_btn_class(is_only_follows, type:)
    case type
    when :all
      is_only_follows ? 'btn-outline-primary' : 'btn-primary'
    when :follow
      is_only_follows ? 'btn-primary' : 'btn-outline-primary'
    end
  end

  def comment_text(timelineable)
    if commentable?(timelineable)
      "コメント #{timelineable.comments.count}"
    elsif complete_post?(timelineable)
      "コメント #{timelineable.complete_postable.comments.count}"
    else
      ''
    end
  end

  private

  def commentable?(timelineable)
    timelineable.instance_of?(Goal) || timelineable.instance_of?(Task)
  end

  def complete_post?(timelineable)
    timelineable.instance_of?(CompletePost)
  end
end
