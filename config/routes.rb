Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'

  # get 'static_pages/help'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  # get 'users/new'
  get  '/signup',  to: 'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # RESTfulなURLを通して、ユーザー情報をリソースとして扱える
  resources :users

  # フィッシング詐欺サイトへ遷移
  get    '/loginFAKE',   to: 'sessions#newFAKE'
end
