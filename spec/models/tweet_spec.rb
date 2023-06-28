# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tweetモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { tweet.valid? }

    let(:user) { create(:user) }
    let!(:tweet) { build(:tweet, user_id: user.id) }

    context "tweet_contentカラム" do
      it "空欄でないこと" do
        tweet.tweet_content = ""
        is_expected.to eq false
      end
      it "200文字以下であること: 200文字はOK" do
        tweet.tweet_content = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it "200文字以下であること: 201文字はNG" do
        tweet.tweet_content = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Userモデルとの関係" do
      it "N:1となっている" do
        expect(Tweet.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context "Likeモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tweet.reflect_on_association(:likes).macro).to eq :has_many
      end
    end

    context "TweetCommentモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tweet.reflect_on_association(:tweet_comments).macro).to eq :has_many
      end
    end

    context "Hashtagモデルとの関係" do
      it "1:Nとなっている" do
        expect(Tweet.reflect_on_association(:hashtags).macro).to eq :has_many
      end
      it "hashtag_relationsを通じた関係となっている" do
        expect(Tweet.reflect_on_association(:hashtags).options[:through]).to eq :hashtag_relations
      end
    end
  end
end
