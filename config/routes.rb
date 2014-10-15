Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  resources :video_queues, only: [:show]
  resources :users
  resources :categories
  get 'ui(/:action)', controller: 'ui'

  resources :videos do
  	collection do
  	 get :search, to:"videos#search"
  	end
    post 'add', to: 'video_queues#add'
    resources :reviews, only: [:create, :new]
  end

end
