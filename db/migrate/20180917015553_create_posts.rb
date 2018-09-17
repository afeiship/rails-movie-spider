class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, id: false do |t|
      t.string :key, limit: 8, auto_increment: false, primary_key: true
      t.string :title
      t.text :content
      t.integer :category_id
      t.float :rate
      t.string :cover
      t.datetime :release_date
      t.string :attachments, limit: 2000

      t.timestamps
    end
  end
end
