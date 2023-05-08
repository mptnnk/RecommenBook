class Genre < ApplicationRecord
  
  def self.all
    RakutenWebService::Books::Genre
  end
  
end
