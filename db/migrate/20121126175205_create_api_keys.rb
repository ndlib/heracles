class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :heracles_api_keys do |t|
      t.string :key
      t.string :name
      t.boolean :is_alive

      t.timestamps
    end
    add_index :heracles_api_keys, :key, :unique => true
  end
end
