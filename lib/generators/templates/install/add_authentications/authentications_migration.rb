class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.string :name

      t.timestamps
    end
  end
end
