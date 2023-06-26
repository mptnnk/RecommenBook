# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'FavoriteBookモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    subject { favorite_book.valid? }
    
    let(:user) { create(:user) }
    let!(:favorite_book) { build(:favorite_book, user_id: user.id ) }
    
    context 'isbnカラム' do
      it 'userが同じISBNの本を繰り返し登録できないこと' do
        # other_favorite_book = build(:favorite_book, user_id: user.id)
        isbn = Faker::Code.isbn
        favorite_book1 = create(:favorite_book, user_id: user.id, isbn: isbn )
        expect(favorite_book1).to be_valid
        # favorite_book1で生成するデータはcreateで保存しておかないとfavorite_book2のバリデーションチェックに使えない
        
        favorite_book2 = build(:favorite_book, user_id: user.id, isbn: isbn )
        expect(favorite_book2).to be_invalid
      end
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Userモデル絵との関係' do
      it 'N:1となっている' do
        expect(FavoriteBook.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
  
end