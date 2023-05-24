module Public::TweetsHelper
  def render_tweet_with_hashtags(tweet_content, length)
    tweet_content.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
  end
end
