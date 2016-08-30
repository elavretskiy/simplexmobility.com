class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, null: false, unique: true
      t.string :url, null: false

      t.timestamps null: false
    end

    add_index :brands, :name
  end
end
