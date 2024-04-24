# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactionsHelper do
  describe 'reaction_form_id_name' do
    let(:reaction) { create(:reaction) }
    let(:reactionable) { reaction.reactionable }

    context 'コメントのリアクションの場合' do
      it '適切なクラス名が返る' do
        expect(reaction_form_id_name(reactionable)).to eq "comment_reaction_form#{reactionable.id}"
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:reaction) { create(:reaction, :complete_post) }

      it '適切なクラス名が返る' do
        expect(reaction_form_id_name(reactionable)).to eq "complete_post_reaction_form#{reactionable.id}"
      end
    end
  end

  describe 'reaction_count_id_name' do
    let(:reaction) { create(:reaction) }
    let(:reactionable) { reaction.reactionable }

    context 'コメントのリアクションの場合' do
      it '適切なクラス名が返る' do
        expect(reaction_count_id_name(reactionable)).to eq "comment_reaction_count#{reactionable.id}"
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:reaction) { create(:reaction, :complete_post) }

      it '適切なクラス名が返る' do
        expect(reaction_count_id_name(reactionable)).to eq "complete_post_reaction_count#{reactionable.id}"
      end
    end
  end

  describe 'reactionable_path' do
    let(:reaction) { create(:reaction) }
    let(:reactionable) { reaction.reactionable }

    context 'コメントのリアクションの場合' do
      it 'コメントにいいねするパスが返る' do
        expect(reactionable_path(reaction)).to eq comment_reactions_path(reactionable)
      end
    end

    context '終了投稿のリアクションの場合' do
      let(:reaction) { create(:reaction, :complete_post) }

      it '終了投稿にいいねするパスが返る' do
        expect(reactionable_path(reaction)).to eq complete_post_reactions_path(reactionable)
      end
    end
  end
end
