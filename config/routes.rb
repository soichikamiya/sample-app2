Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

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

  # アカウント有効化用のresources行を追加
  resources :account_activations, only: [:edit]

  # パスワード再設定用リソースを追加
  resources :password_resets, only: [:new, :create, :edit, :update]

  #ポストリソースのRESTfulルート、表示は別ページ内の為 POST/DELETEアクション のみ使用
  resources :microposts, only: [:create, :destroy]

  # フィッシング詐欺サイトへ遷移
  get    '/loginFAKE',   to: 'sessions#newFAKE'
end
