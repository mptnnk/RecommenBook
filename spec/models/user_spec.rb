# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do # describe：テストの大きな括り。必須構成
    subject { user.valid? } # subjectはテストの対象となるオブジェクトやメソッドを指定する。
    let!(:other_user) { create(:user) } # other_userという変数をcreate(:user)によって生成する。createはデータベースにオブジェクトを保存し、結果をother_userに代入する。
    let(:user) { build(:user) } # userという変数をbuild(:user)によって生成する。buildはデータベースにオブジェクトを保存せず、結果をuserに代入する。
    context 'nameカラム' do # context: テストの詳細な括り。describeの下位に任意で構成する
      it '一意性があること' do # it: 具体的なテスト内容を示す
        user.name = other_user.name # userオブジェクトのname属性にother_userオブジェクトのname属性を代入
        is_expected.to eq false # is_expebted.to: subject（今回の場合はuser.valid?）がfalseであることを期待している # eq: マッチャーの一種。期待値と比較して一致するか
      end
    end
    context 'introductionカラム' do
      it '20文字以下であること: 20文字はOK︎' do
        user.introduction = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字はNG' do
        user.introduction = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Reviewモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:reviews).macro).to eq :has_many
      end
    end
    
    context 'Tweetモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:tweets).macro).to eq :has_many
      end
    end
    
    context 'FavoriteBookモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorite_books).macro).to eq :has_many
      end
    end
    
    context 'ReadingListモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:reading_lists).macro).to eq :has_many
      end
    end
    
    context 'FavoriteGenreモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorite_genres).macro).to eq :has_many
      end
    end
    
    context 'Genreモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:genres).macro).to eq :has_many
      end
      it 'FavoriteGenreモデルを通じた関係となっている' do
        expect(User.reflect_on_association(:genres).options[:through]).to eq :favorite_genres
      end
    end
    
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
    
    context 'ReviewCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:review_comments).macro).to eq :has_many
      end
    end
    
    context 'TweetCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:tweet_comments).macro).to eq :has_many
      end
    end
    
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:followings).macro).to eq :has_many
        expect(User.reflect_on_association(:followers).macro).to eq :has_many
      end
      it 'Relationshipモデルを通じた関係となっている' do
        expect(User.reflect_on_association(:followings).options[:through]).to eq :relationships
        expect(User.reflect_on_association(:followings).options[:source]).to eq :followed
        expect(User.reflect_on_association(:followers).options[:through]).to eq :reverse_of_relationships
        expect(User.reflect_on_association(:followers).options[:source]).to eq :follower
      end
    end
  end
end