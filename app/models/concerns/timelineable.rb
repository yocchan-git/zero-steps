# frozen_string_literal: true

module Timelineable
  def formatted_text(timelineable)
    message = timelineable.instance_of?(Goal) ? timelineable.title : timelineable.content
    message.length <= 20 ? message : "#{message[0...20]}..."
  end
end
