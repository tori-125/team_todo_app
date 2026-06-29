class SessionsController < ApplicationController
  # ログイン画面の表示（new）と、ログイン処理（create）だけは、親の検問をスキップする
  skip_before_action :require_login, only: [:new, :create]

  def new
    # ログイン画面を表示するだけ
  end

  def create
    # 送られてきたアドレスでユーザーを検索
    user = User.find_by(email: params[:email])

    # ユーザーが見つかり、かつパスワードが合っているかチェック
    if user && user.authenticate(params[:password])
      # 成功なら、ブラウザの「セッション」にユーザーIDを保存（通常のログイン状態にする）
      session[:user_id] = user.id

      # ログイン保持のチェックボックスがON（"1"）のとき
      if params[:remember_me] == "1"
        # 永続的（permanent）かつ暗号化（signed）されたクッキーにユーザーIDを刻む
        cookies.permanent.signed[:user_id] = user.id
      else
        # チェックボックスがOFFのときは、古いクッキーが残っていれば消去する
        cookies.delete(:user_id)
      end

      redirect_to root_path, notice: "ログインしました！"
    else
      # 失敗なら、もう一度ログイン画面を表示
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # セッションとクッキーの両方からユーザーIDを消去して、完全にログアウト状態にする
    session[:user_id] = nil
    cookies.delete(:user_id)
    redirect_to login_path, notice: "ログアウトしました！"
  end

end