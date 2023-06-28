# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FavoriteGenreモデルのテスト", type: :model do
  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(FavoriteGenre.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "Genreモデルとの関係" do
      it "N:1となっている" do
        expect(FavoriteGenre.reflect_on_association(:genre).macro).to eq :belongs_to
      end
    end
  end
end
