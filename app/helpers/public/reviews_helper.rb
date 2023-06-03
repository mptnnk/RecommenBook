module Public::ReviewsHelper
  def render_review_with_hashtags(content, length = nil)
    if length.nil?
      content.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/hashtag/#{word.delete("#＃")}"}.html_safe
    else
      hash_tags = content.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      content.truncate(length).gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| hash_tags.include?(word) ? (link_to word, "/hashtag/#{word.delete("#＃")}") : word}.html_safe
    end
  end
end