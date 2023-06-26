# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'FavoriteGenreモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    subject { favorite_genre.valid? }
    
    let(:user) { crate(:user) }
    let(:genre) { create(:genre) }
    let!(:favorite_genre) { FactoryBot.build(:favorite_genre, user_id: user.id, genre_id: genre.id) }
  end
end