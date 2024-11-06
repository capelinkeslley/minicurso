class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
