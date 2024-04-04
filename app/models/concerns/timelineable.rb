# frozen_string_literal: true

module Timelineable
  def formatted_text(timelineable)
    message = goal?(timelineable) ? timelineable.title : timelineable.content
    message.length <= 20 ? message : "#{message[0...20]}..."
  end

  def goal?(timelineable)
    timelineable.instance_of?(Goal)
  end
end
