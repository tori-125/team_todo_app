class ApplicationController < ActionController::Base
  # アプリ内のすべての画面でcurrent_userを使えるようにする
  helper_method :current_user

  # すべての画面を表示する前に、共通の検問（require_login）を必ず実行する
  before_action :require_login

  private

  # 今ログインしているユーザーを特定して返すメソッド
  def current_user
    # まずは通常の一時的なセッションを確認する
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    # セッションが無く、暗号化されたクッキーに記憶が残っている場合
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user
        # 次回からのために一時セッションも復元しておく
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  # 管理者かどうかを判定し、一般ユーザーならタスク一覧へ弾き返す
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者権限がありません。"
    end
  end

  # ログインしていない場合にログイン画面へ強制送還するメソッド
  def require_login
    unless current_user
      # もしログインしていなかったら、ログイン画面に追い返す
      redirect_to login_path, alert: "ログインしてください。"
    end
  end
end