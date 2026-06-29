namespace :cleanup do
  desc "完了してから6ヶ月経過したタスクを自動で削除する"
  task tasks: :environment do
    puts "【お掃除開始】古いタスクの削除を始める"

    # 今から「6ヶ月前の時間」を計算する
    boundary_date = 6.months.ago

    # 1. statusが「completed（完了）」で
    # 2. updated_at（最後に更新された時間＝完了した時間）が6ヶ月より前（< boundary_date）
    # のタスクを探し出す
    old_tasks = Task.completed.where("updated_at < ?", boundary_date)

    # 見つかった件数をメモ
    count = old_tasks.count

    # 条件に合うタスクを一斉に削除！
    old_tasks.destroy_all

    puts "【お掃除完了】#{count}件の古い完了タスクを削除が完了"
  end
end