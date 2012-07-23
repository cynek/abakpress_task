class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :text
      t.references :page

      t.timestamps
    end
    add_index :pages, :page_id
    add_index :pages, [:page_id, :name], :unque => true
  end
end
