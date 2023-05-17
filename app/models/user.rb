class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true
  
  has_many :reviews, dependent: :destroy
  has_many :favorite_books, dependent: :destroy
  # おすすめ本1冊しか登録できない仕様ならhas_oneだけど、読みたい本とかお気に入りとかを登録するのにbookテーブルを使えるならhas_manyがいいかも
  has_many :readed_books, dependent: :destroy
  has_many :tweets, dependent: :destroy
  
  has_one_attached :profile_image
  
  def get_profile_image
    (profile_image.attached?) ? pdofile_image: 'default-image.jpg'
  end
  
  def to_param
    name
  end
  
end