class AdminSettingsController < ApplicationController
  # 一般ユーザーがURL直打ちで入ってきても、タスク一覧へ追い返す
  before_action :require_admin

  def index
    # 登録されているカテゴリを全部取ってくる
    @categories = Category.order(:position)
    # 新しいカテゴリを作るための空っぽの箱を用意しておく
    @category = Category.new

    @teams = Team.order(:position)
    @team = Team.new
  end

  # カテゴリを新しく保存する
  def create_category
    @category = Category.new(category_params)
    if @category.save
      # 保存に成功したら、メッセージを出して管理者設定画面に戻る
      redirect_to admin_settings_path, notice: "カテゴリ「#{@category.name}」を追加しました。"
    else
      # もし空っぽなどの理由で失敗したら、一覧を再取得して画面を戻す
      @categories = Category.all
      render :index, status: :unprocessable_entity
    end
  end

  # カテゴリを消去する
  def destroy_category
    category = Category.find(params[:id])
    category.destroy
    redirect_to admin_settings_path, notice: "カテゴリ「#{category.name}」を削除しました。"
  end

  # チームを新しく保存する
  def create_team
    @team = Team.new(team_params)
    if @team.save
      redirect_to admin_settings_path, notice: "チーム「#{@team.name}」を追加しました。"
    else
      # エラーで戻る時も、カテゴリのデータをしっかり用意しておく
      @categories = Category.all
      @category = Category.new
      @teams = Team.all
      render :index, status: :unprocessable_entity
    end
  end

  # チームを消去する
  def destroy_team
    team = Team.find(params[:id])
    team.destroy
    redirect_to admin_settings_path, notice: "チーム「#{team.name}」を削除しました。"
  end

  # カテゴリの並べ替え処理
  def sort_category
    category = Category.find(params[:id])
    category.insert_at(params[:new_position].to_i + 1) # acts_as_listで順番を更新
    head :ok # 「処理成功した」とだけ画面にこっそり返す
  end

  # チームの並べ替え処理
  def sort_team
    team = Team.find(params[:id])
    team.insert_at(params[:new_position].to_i + 1)
    head :ok
  end

  private

  # 安全に「カテゴリ名」だけを受け取るための防壁（ストロングパラメータ）
  def category_params
    params.require(:category).permit(:name)
  end

  def team_params
    params.require(:team).permit(:name)
  end

end