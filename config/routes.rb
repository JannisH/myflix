Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'follow', to: 'relationships#follow'
  resources :video_queues, only: [:show] do
    put 'update', to: 'video_queues#update'
  end
  resources :users do
    delete 'unfollow', to: 'relationships#destroy'
  end
  resources :relationships, only: [:index, :create]
  resources :categories
  get 'ui(/:action)', controller: 'ui'

  resources :videos do
  	collection do
  	 get :search, to:"videos#search"
  	end
    post 'add', to: 'video_queues#add'
    delete 'remove', to: 'video_queues#remove'
    resources :reviews, only: [:create, :new]
  end

end
