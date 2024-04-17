# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetaTagsHelper do
  describe 'default_meta_tags' do
    let(:meta_tags) { default_meta_tags(page_title) }

    context 'page_titleを設定していない場合' do
      let(:page_title) { '' }

      it 'デフォルトのタイトルや詳細が設定される' do
        expect(meta_tags[:title]).to eq 'Zero Steps'
        expect(meta_tags[:description]).to eq 'Zero Stepsは目標をタスク化し、進捗などを共有して励まし合うアプリです。'
      end
    end

    context 'page_titleを設定している場合' do
      let(:page_title) { 'ログイン' }

      it 'meta titleが正しく設定されていること' do
        expect(meta_tags[:title]).to eq 'ログイン | Zero Steps'
      end

      it 'meta descriptionが正しく設定されていること' do
        expect(meta_tags[:description]).to eq 'Zero Stepsは目標をタスク化し、進捗などを共有して励まし合うアプリです。 | 今のページ:ログイン'
      end

      it 'ogp用の設定されていること' do
        expect(meta_tags[:og][:site_name]).to eq :site
      end

      it 'twitter cardが設定されていること' do
        expect(meta_tags[:twitter][:card]).to eq 'summary_large_image'
      end
    end
  end
end
