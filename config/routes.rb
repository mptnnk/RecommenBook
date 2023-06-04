Rails.application.routes.draw do

  devise_for :admin, skip:[:registrations,:passwords], controllers:{
    sessions:'admin/sessions'
  }

  devise_for :users, controllers:{
    sessions:'public/sessions',
    registrations:'public/registrations',
    passwords:'public/passwords'
  }
  
  devise_scope :user do
    get 'users', to: 'public/registrations#new'
  end
  
  # devise_scope :user do
  #   post 'users/guest_sign_in', to: 'public/sessions#new_guest'
  # end
  
  scope module: :public do
    root to:'homes#top'
    get '/about' => 'homes#about', as:"about"
    # get '/search' => 'homes#search', as:"search"

    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    get 'users/favorite_genres' => 'users#favorite_genres'
    get 'users/:name' => 'users#show', as: 'mypage'
    get 'users/:name/sm' => 'users#profile', as: 'mypage_sm'
    get 'users/information/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    
    resources :users, only:[] do
      resource :relationships, only: [:create, :destroy]
    end
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    
    get 'books/search' => "books#search"
    get 'hashtag/:hashname' => "hashtags#index", as: 'hashtag'
    get 'readed_list' => "reviews#readed_list", as: 'readed_list'
    
    get 'comments' => 'review_comments#index', as: "comments"
    # resources :review_comments, only: [:index], as: "comments"
    
    resources :books, only: [:show] do
      resources :reviews, only: [:new, :create]
      resources :favorite_books, only: [:create, :destroy]
      resources :reading_lists, only: [:destroy, :create]
    end
    resources :reviews, only: [:index, :show, :edit, :update, :destroy] do
      resources :review_comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
    resources :favorite_books, only: [:index, :update]
    resources :reading_lists, only: [:index]
    resources :tweets, only: [:new, :create, :index, :show, :destroy] do
      resources :tweet_comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
    resources :likes, only: [:index]
    
  end
  
  namespace :admin do
    get '/' => 'homes#top'
    resources :users, only: [:index, :edit, :update]
    resources :reviews, only: [:show, :update, :destroy]
    resources :tweets, only: [:index, :show, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end