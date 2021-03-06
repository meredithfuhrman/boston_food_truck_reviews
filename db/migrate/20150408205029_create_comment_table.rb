class CreateCommentTable < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :review_id, null: false
      t.integer :user_id, null: false
      t.text :comment_body, null: false
      t.timestamps
    end
  end
end
