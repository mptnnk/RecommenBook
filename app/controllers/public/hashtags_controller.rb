class Public::HashtagsController < ApplicationController
  def index
    @tag = Hashtag.find_by(name: params[:name])
    # @tag = Hashtag.where("LOWER(name) =  ?", "%#{params[:name].downcase}%").first
    # @reviews = @tag.reviews.order(created_at: :desc)
    @reviews = Review.joins(:hashtags).where("LOWER(hashtags.name) =  ?", params[:name].downcase)
    @tweets = Tweet.joins(:hashtags).where("LOWER(hashtags.name) = ?", params[:name].downcase)
    # joinsでテーブルを内部結合し、条件一致するレコードの複数取得を可能にする。
    # データベースから取得したhashtags.nameをLOWERで小文字に変換。whereメソッドの？はプレースホルダーと呼ばれ、第二引数に指定した値に置き換える。
    # データベースから取得した値とプレースホルダーをイコールで結んでいるので、送られたparams[:name]が?に渡される。
    # findやfind_byは1件ずつレコードを取得するが、該当するレコードを全部探す場合はwhereを使う。
    @posts = (@reviews + @tweets).uniq.sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
  end
end
