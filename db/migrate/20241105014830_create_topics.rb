class CreateTopics < ActiveRecord::Migration[8.0]
  def change
    create_table :topics do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :is_private, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
