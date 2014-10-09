Myflix::Application.routes.draw do
  root to: 'videos#index'
  resources :videos
  resources :categories

  get 'ui(/:action)', controller: 'ui'
end
