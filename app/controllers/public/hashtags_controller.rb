class Public::HashtagsController < ApplicationController
  before_action :set_userinfo
  
  def index
    @tag = Hashtag.find_by(hashname: params[:hashname])
    @reviews = Review.joins(:hashtags).where("LOWER(hashtags.hashname) =  ?", params[:hashname].downcase)
    @tweets = Tweet.joins(:hashtags).where("LOWER(hashtags.hashname) = ?", params[:hashname].downcase)
    # joinsでテーブルを内部結合し、条件一致するレコードの複数取得を可能にする。
    # データベースから取得したhashtags.hashnameをLOWERで小文字に変換。whereメソッドの？はプレースホルダーと呼ばれ、第二引数に指定した値に置き換わる。
    # データベースから取得した値とプレースホルダーをイコールで結んでいるので、送られたparams[:hashname]が?に渡される。
    # findやfind_byは1件ずつレコードを取得するが、該当するレコードを全部探す場合はwhereを使う。
    @posts = (@reviews + @tweets).uniq.sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
  end
end
