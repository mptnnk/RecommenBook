# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Genreモデルのテスト', type: :model do
  
  describe 'アソシエーションのテスト' do
    context 'FavoriteGenreモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:favorite_genres).macro).to eq :has_many
      end
    end
    context 'Userモデルとの関係' do
      it '1:Nとなっている' do
        expect(Genre.reflect_on_association(:users).macro).to eq :has_many
      end
      it 'favorite_genresを通じた関係となっている' do
        expect(Genre.reflect_on_association(:users).options[:through]).to eq :favorite_genres
      end
    end
  end
  
end