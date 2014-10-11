Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  resources :videos do
  	collection do
  	 get :search, to:"videos#search"
  	end
  end
  resources :users

  resources :categories

  get 'ui(/:action)', controller: 'ui'

end
