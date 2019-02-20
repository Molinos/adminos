class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string   :name

      t.string :email
      t.string :phone
      t.text :message

      t.timestamps null: false
    end
  end
end
