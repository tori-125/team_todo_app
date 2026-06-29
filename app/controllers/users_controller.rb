class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = 0 # 最初は全員一般メンバー（0）として登録する

    if @user.save
      session[:user_id] = @user.id # 登録と同時に自動でログイン状態にする
      redirect_to root_path, notice: "ユーザー登録が完了しました！"
    else
      render :new, status: :unprocessable_entity # render :new＝登録失敗したらnew画面を再表示
    end
  end

  # プロフィール編集画面を表示する
  def edit
    # ログインしている自分の情報を @user に入れる
    @user = current_user
  end

  # プロフィールの更新処理をする
  def update
    @user = current_user
    
    # 送られてきたデータ（user_params）で上書き保存できたら
    if @user.update(user_params)
      # 成功したら、もう一度プロフィール画面に戻ってメッセージを出す
      redirect_to profile_path, notice: "個人設定を更新しました！"
    else
      # 失敗したら、編集画面（edit.html.erb）をもう一度表示してエラーを出す
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # 安全に入力データを受け取るための仕組み（ストロングパラメーター）
  def user_params
    params.expect(user: [:name, :team_id, :email, :password, :password_confirmation])
  end
end