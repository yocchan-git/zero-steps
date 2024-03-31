require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe '#formatted_title' do
    let(:goal) { create(:goal, title:) }

    context 'タイトルが20文字の場合' do
      let(:title) { 'a' * 20 }

      it 'そのまま表示される' do
        expect(goal.formatted_title).to eq title
      end
    end

    context 'タイトルが21文字の場合' do
      let(:title) { 'a' * 21 }

      it '「20文字分+...」で表示される' do
        expect(goal.formatted_title).to eq "#{'a' * 20}..."
      end
    end
  end
end
