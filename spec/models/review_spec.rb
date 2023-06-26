# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Reviewモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    subject { review.valid? }
    let!(:review) { build(:review) }
    context 'contentカラム' do
      it '500文字以下であること: 500文字は○' do
        review.content = Faker::Lorem.characters(number: 500)
        is_expected.to eq true
      end
      it '500文字以下であること: 501文字は×' do
        review.content = Faker::Lorem.characters(number: 501)
        is_expected.to eq false
      end
    end
    
  end
  
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Review.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(Review.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    
    context 'ReviewCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Review.reflect_on_association(:review_comments).macro).to eq :has_many
      end
    end
    
    context 'Hashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(Review.reflect_on_association(:hashtags).macro).to eq :has_many
      end
      it 'hashtag_relationsを通じた関係となっている' do
        expect(Review.reflect_on_association(:hashtags).options[:through]).to eq :hashtag_relations
      end
    end
    
  end
  
end