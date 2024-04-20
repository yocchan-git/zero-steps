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
end
