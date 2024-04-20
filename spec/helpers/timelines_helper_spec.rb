# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimelinesHelper do
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
