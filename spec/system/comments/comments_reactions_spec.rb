require 'rails_helper'

RSpec.describe "Comments::Reactions", type: :system do
  before { login(user) }
  let(:user) { create(:user) }
  let(:goal) { create(:goal) }
  let!(:comment) { create(:comment, commentable: goal) }

  describe '#create' do
    it 'いいねができること' do
      visit goal_comments_path(goal)
      within "#comment_reaction_form#{comment.id}" do
        find('.btn').click
        expect(page).to have_css '.fa-solid'
      end
    end
  end
end
