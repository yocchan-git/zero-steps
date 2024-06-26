# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  include ERB::Util

  describe 'escaped_simple_format' do
    let(:formatted_text) { escaped_simple_format(text) }

    context '改行なしの通常の文章の場合' do
      let(:text) { '目標を作成しました！' }

      it 'pタグで囲まれる' do
        expect(formatted_text).to eq '<p>目標を作成しました！</p>'
      end
    end

    context '改行ありの文章の場合' do
      let(:text) { "目標を作成しました！\n応援よろしくお願いします" }

      it '\nの部分はbrタグが追加される' do
        expect(formatted_text).to eq "<p>目標を作成しました！\n<br />応援よろしくお願いします</p>"
      end
    end

    context 'HTMLダグが含まれている場合' do
      let(:text) { '<h1>野外フェスを成功させたい！</h1>' }

      it '入力されたHTMLタグはエスケープされる' do
        expect(formatted_text).to eq '<p>&lt;h1&gt;野外フェスを成功させたい！&lt;/h1&gt;</p>'
      end
    end
  end

  describe 'group_btn_class' do
    let(:class_name) { group_btn_class(is_only_follows, type:) }

    context 'typeが全ての場合' do
      let(:type) { :all }

      context 'フォローで絞り込んでいる場合' do
        let(:is_only_follows) { true }

        it 'btn-outline-primaryが返る' do
          expect(class_name).to eq 'btn-outline-primary'
        end
      end

      context 'フォローで絞り込んでいない場合' do
        let(:is_only_follows) { false }

        it 'btn-primaryが返る' do
          expect(class_name).to eq 'btn-primary'
        end
      end
    end

    context 'typeがフォローの場合' do
      let(:type) { :follow }

      context 'フォローで絞り込んでいる場合' do
        let(:is_only_follows) { true }

        it 'btn-primaryが返る' do
          expect(class_name).to eq 'btn-primary'
        end
      end

      context 'フォローで絞り込んでいない場合' do
        let(:is_only_follows) { false }

        it 'btn-outline-primaryが返る' do
          expect(class_name).to eq 'btn-outline-primary'
        end
      end
    end
  end
end
