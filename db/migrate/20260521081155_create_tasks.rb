class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :status

      t.timestamps
    end
  end
end
