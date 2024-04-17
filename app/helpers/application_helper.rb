# frozen_string_literal: true

module ApplicationHelper
  include Timelineable

  def escaped_simple_format(text)
    escaped_text = h(text)
    simple_format(escaped_text)
  end
end
