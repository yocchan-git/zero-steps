# frozen_string_literal: true

class CompleteUpdater
  include Timelineable

  def initialize(complete_postable, user, params)
    @complete_postable = complete_postable
    @user = user
    @params = params
  end

  def execute
    @complete_postable.update!(completed_at: Time.current)
    @complete_post = create_complete_post
    create_timeline
  end

  private

  def create_complete_post
    complete_post = @complete_postable.build_complete_post(@params)
    complete_post.user = @user
    complete_post.save!

    complete_post
  end

  def create_timeline
    @complete_post.timelines.create!(user: @user,
                                     content: "#{@user.name}さんが#{formatted_text(@complete_postable)}という#{complete_postable_name}を終了しました")
  end

  def complete_postable_name
    goal?(@complete_postable) ? '目標' : 'タスク'
  end
end
