Rails.application.routes.draw do

  devise_for :admin, skip:[:registrations,:passwords], controllers:{
    sessions:'admin/sessions'
  }

  devise_for :users, controllers:{
    sessions:'public/sessions',
    registrations:'public/registrations',
    passwords:'public/passwords'
  }
  
  # devise_scope :user do
  #   post 'users/guest_sign_in', to: 'public/sessions#new_guest'
  # end
  
  scope module: :public do
    root to:'homes#top'
    get '/about' => 'homes#about', as:"about"
    
    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    get 'users/favorite_genres' => 'users#favorite_genres'
    get 'users/:name' => 'users#show', as: 'mypage'
    get 'users/information/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    
    resources :users, only:[] do
      resource :relationships, only: [:create, :destroy]
      # get 'followings' => 'relationships#followings', as: 'followings'
      # get 'followers' => 'relationships#followers', as: 'followers'
    end
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    
    get 'books/search' => "books#search"
    get 'hashtag/:name' => "hashtags#index", as: 'hashtag'
    
    resources :books, only: [:show] do
      resources :reviews, only: [:new, :create]
      resources :favorite_books, only: [:create, :destroy]
      resources :readed_books, only: [:destroy, :create]
    end
    resources :reviews, only: [:index, :show, :edit, :update, :destroy] do
      resources :review_comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
    resources :favorite_books, only: [:index, :update]
    resources :readed_books, only: [:index]
    resources :tweets, only: [:new, :create, :index, :show, :destroy] do
      resources :tweet_comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
    resources :likes, only: [:index]
    resources :review_comments, only: [:index], as: "comments"
  end
  
  namespace :admin do
    get '/' => 'homes#top'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end