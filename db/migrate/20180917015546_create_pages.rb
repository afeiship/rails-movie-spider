class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :key
      t.string :url
      t.boolean :grabbed

      t.timestamps
    end
  end
end
