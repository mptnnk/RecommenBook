module Public::TweetsHelper
  def render_tweet_with_hashtags(tweet_content, length = nil)
    if length.nil?
      tweet_content.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
    else
      tweet_content.truncate(length).gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
    end
  end
end
