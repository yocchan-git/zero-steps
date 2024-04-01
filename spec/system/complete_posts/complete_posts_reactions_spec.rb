require 'rails_helper'

RSpec.describe "CompletePosts::Reactions", type: :system do
  before { login(user) }
  let(:user) { create(:user) }
  let(:goal) { create(:goal, :completed) }
  let!(:complete_post) { create(:complete_post, complete_postable: goal) }

  describe '#create' do
    it 'いいねができること' do
      visit goal_path(goal)
      within "#complete_post_reaction_form#{complete_post.id}" do
        find('.btn').click
        expect(page).to have_css '.fa-solid'
      end
    end
  end
end
