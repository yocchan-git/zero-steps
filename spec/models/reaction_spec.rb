require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe '#comment?' do
    context 'コメントのリアクションの場合' do
      let(:comment_reaction) { create(:reaction, :comment) }

      it 'trueで返る' do
        expect(comment_reaction.comment?).to be_truthy
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:complete_post_reaction) { create(:reaction, :complete_post) }

      it 'falseが返る' do
        expect(complete_post_reaction.comment?).to be_falsy
      end
    end
  end

  describe '#reaction_form_id_name' do
    context 'コメントのリアクションの場合' do
      let(:comment_reaction) { create(:reaction, :comment) }

      it '適切なクラス名が返る' do
        expect(comment_reaction.reaction_form_id_name).to eq "comment_reaction_form#{comment_reaction.reactionable.id}"
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:complete_post_reaction) { create(:reaction, :complete_post) }

      it '適切なクラス名が返る' do
        expect(complete_post_reaction.reaction_form_id_name).to eq "complete_post_reaction_form#{complete_post_reaction.reactionable.id}"
      end
    end
  end

  describe '#reaction_count_id_name' do
    context 'コメントのリアクションの場合' do
      let(:comment_reaction) { create(:reaction, :comment) }

      it '適切なクラス名が返る' do
        expect(comment_reaction.reaction_count_id_name).to eq "comment_reaction_count#{comment_reaction.reactionable.id}"
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:complete_post_reaction) { create(:reaction, :complete_post) }

      it '適切なクラス名が返る' do
        expect(complete_post_reaction.reaction_count_id_name).to eq "complete_post_reaction_count#{complete_post_reaction.reactionable.id}"
      end
    end
  end
end
