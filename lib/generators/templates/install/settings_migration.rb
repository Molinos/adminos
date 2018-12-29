class CreateSettings < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :settings do |t|
      t.string   :copyright
      t.string   :email
      t.string   :company_name
      t.string   :contact_email
      t.string   :email_header_from
      t.text     :index_meta_description
      t.string   :index_meta_title
      t.integer  :per_page, default: 10
      t.text     :seo_google_analytics
      t.text     :seo_yandex_metrika
    end
  end
end
