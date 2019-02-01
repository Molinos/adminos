      t.string   :name
      t.boolean  :published, default: true, null: false
      t.string   :slug
      t.integer  :parent_id
      t.integer  :depth, default: 0
      t.integer  :lft
      t.integer  :rgt
