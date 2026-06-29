Rails.application.routes.draw do

  # タスクに関するすべて（new_task_pathなども含む）を自動作成
  resources :tasks do

    # 特定のタスクのステータスを切り替える
    member do
      patch :toggle_status
    end

    # 完了済みのタスクを「全員まとめて」一覧表示する
    collection do
      get :completed
    end
  end
  
  # ログイン・ログアウト
  # as: "〇〇" =〇〇_pathというあだ名が使えるようになる
  get "login", to: "sessions#new", as: "login"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: "logout"

  # 新規登録のためのURL
  get  "signup", to: "users#new", as: "signup"
  post "signup", to: "users#create"

  # プロフィール編集のためのURL
  get   "profile", to: "users#edit", as: "profile"
  patch "profile", to: "users#update"

  # 管理者専用ページへのルート（一覧表示、追加、削除）
  get "admin_settings", to: "admin_settings#index", as: "admin_settings"
  post "admin_settings/categories", to: "admin_settings#create_category", as: "create_category_admin_settings"
  delete "admin_settings/categories/:id", to: "admin_settings#destroy_category", as: "destroy_category_admin_settings"

  # カテゴリとチームの順番を並べ替える
  patch 'admin_settings/sort_category', to: 'admin_settings#sort_category', as: :sort_category_admin_settings
  patch 'admin_settings/sort_team', to: 'admin_settings#sort_team', as: :sort_team_admin_settings

  # チームの追加と削除の道
  post "admin_settings/teams", to: "admin_settings#create_team", as: "create_team_admin_settings"
  delete "admin_settings/teams/:id", to: "admin_settings#destroy_team", as: "destroy_team_admin_settings"

  # アプリの仮のトップページ
  root "tasks#index"
end