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
    # controller :homes
    root to:'homes#top'
    get '/about' => 'homes#about', as:"about"
    
    # controller :users
    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
    # idつきのものが上にあると先に読んでしまってunsubscribeに遷移できなかったので上に出した
    get 'users/:name' => 'users#show', as: 'mypage'
    get 'users/information/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    
    # booksコントローラ
    get 'books/search' => "books#search"
    post 'books/favorite' => "books#add_favorite"
    
    resources :books, only: [:show] do
      resources :reviews, only: [:new, :create]
    end
  end
  
  # namespace :public do
  #   #   get 'homes/top'
  #   #   get 'homes/about'
  #   get 'users/index'
  #   get 'users/show'
  #   get 'users/edit'
  #   get 'users/unsubscribe'
  #   get 'reviews/new'
  #   get 'reviews/index'
  #   get 'reviews/show'
  #   get 'reviews/edit'
  # # end
  
  namespace :admin do
    get '/' => 'homes#top'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end