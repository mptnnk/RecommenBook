module Public::ReviewsHelper
  def render_review_with_hashtags(content, length = nil)
    if length.nil?
      content.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
    else
      content.truncate(length, separator: "＃").gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
    end
  end
end