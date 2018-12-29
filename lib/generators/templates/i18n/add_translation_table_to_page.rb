class AddTranslationTableToPage < ActiveRecord::Migration[5.1]
  def up
    Page.create_translation_table!({
      name: :string,
      nav_name: :string,
      body: :text,
      meta_description: :text,
      meta_title: :string
    },       migrate_data: true)
  end

  def down
    Page.drop_translation_table! migrate_data: true
  end
end
