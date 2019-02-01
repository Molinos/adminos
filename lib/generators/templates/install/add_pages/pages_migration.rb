class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string   :behavior,      default: 'pages', null: false
      t.integer  :parent_id
      t.integer  :lft
      t.integer  :rgt
      t.integer  :depth,         default: 0, null: false
      t.string   :slug
      t.string   :path
      t.boolean  :nav_published, default: false, null: false
      t.boolean  :published,     default: false, null: false
      t.string   :name
      t.string   :nav_name
      t.text     :body

      t.timestamps
    end

    add_index :pages, :rgt
    add_index :pages, :parent_id
  end
end
