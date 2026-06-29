class TasksController < ApplicationController
  # アクションを実行する前に、必ずrequire_loginのチェックを入れる
  before_action :require_login

  def index
    if params[:filter] == "completed"
      # 【完了済一覧のとき】
      if params[:scope] == "team"
        # チームの完了済タスク
        team_user_ids = User.where(team_id: current_user.team_id).pluck(:id)
        @tasks = Task.where(user_id: team_user_ids, status: :completed).order(updated_at: :desc)
      else
        # 自分の完了済タスク
        @tasks = current_user.tasks.completed.order(updated_at: :desc)
      end
    elsif params[:scope] == "team"
      # 【TEAM一覧のとき】★新設！
      # 1. ★【修正】自分と同じチームID（team_id）を持つユーザーのIDをすべて集める
      team_user_ids = User.where(team_id: current_user.team_id).pluck(:id)
      
      # 2. そのチームメンバー全員のタスクを、期限が近い順にすべて取得する
      @tasks = Task.where(user_id: team_user_ids).order(due_date: :asc)
      
      # 3. ★【修正】画面で3列（ユーザーごと）に分けるために、同じチームIDのユーザーリストを取得しておく
      @team_users = User.where(team_id: current_user.team_id)
    else
      # 【通常（MY）一覧のとき】
      # タスクを期限が近い順（古い順：asc）にすべて取得
      @tasks = current_user.tasks.order(due_date: :asc)
    end
  end

  def show
    # すべてのタスクからIDで直接特定
    @task = Task.find(params[:id])

    # ★【修正】もし見ようとしたタスクの担当者のチームIDが、自分のチームIDと違っていたら
    if @task.user.team_id != current_user.team_id
      # マイタスク一覧に強制送還し、警告メッセージを表示
      redirect_to tasks_path, alert: "同じチームのタスク以外は閲覧できません。"
    end
  end

  def new
    # ログインユーザーに紐づいた、新しい空っぽのタスクの箱を作る
    @task = current_user.tasks.new
  end

  def create
    # 画面から送られてきたタイトルや内容を元に、タスクを作る
    @task = current_user.tasks.new(task_params)
    @task.status = 0 # 最初は「未完了（0）」として保存

    if @task.save
      redirect_to tasks_path, notice: "タスクを登録しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集画面
  def edit
    # 今ログインしている人のタスクの中から、編集したいタスクを1件だけ特定する
    @task = current_user.tasks.find(params[:id])
  end

  # データベースを書き換える
  def update
    @task = current_user.tasks.find(params[:id])

    # 新しく入力された値（task_params）で更新
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # データベースからタスクを完全に消す
  def destroy
    # 今ログインしている人のタスクの中から、消したいタスクを見つける
    @task = current_user.tasks.find(params[:id])
    
    # そのタスクをデータベースから消去
    @task.destroy
    
    # 3. 削除したら、一覧画面に戻して「削除しました」と報告
    # ※ Rails 7 以降では、削除後のリダイレクトに status: :see_other をつける
    redirect_to tasks_path, notice: "タスクを削除しました！", status: :see_other
  end

  # ステータスを次の段階へ進めるアクション
  def toggle_status
    @task = current_user.tasks.find(params[:id])

    # 現在のステータスに応じて、次の段階へ進化させるぞ！
    if @task.uncompleted?
      @task.doing!        # 未完了 ➔ 進行中 へ
    elsif @task.doing?
      @task.completed!    # 進行中 ➔ 完了 へ
    else
      @task.uncompleted!  # 完了 ➔ 未完了（最初）へ戻す
    end

    # 処理が終わったら、一覧画面へシュッと戻る
    redirect_to tasks_path, notice: "ステータスを更新しました！"
  end
  
  private

  # ストロングパラメーター（安全のために許可するデータを絞る仕組み）
  def task_params
    params.require(:task).permit(:title, :content, :due_date, :category_id, :status)
  end
end