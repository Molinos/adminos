require 'rails/generators/active_record'
require "adminos/generators/utilities"

module Adminos::Generators
  class TwoFactorAuthGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration
    include Utilities

    desc 'Set up 2fa for users'
    source_root File.expand_path '../../templates/two_facto_auth', __FILE__

    def auto
      directory 'auto', '.', mode: :preserve
    end

    def bundle_dependencies
      merge_gemfile_with('Gemfile')
      install_dependencies
    end

    def generate_two_factor
      generate 'devise_two_factor user OTP_SECRET_ENCRYPTION_KEY'
    end

    def routes
      insert_into_file "config/routes.rb", after: "resource  :profile, only: [:edit, :update]\n" do
        <<~ROUT.indent(6)
          resource  :profile, only: [] do
            member { post :toggle_two_factor }
          end
        ROUT
      end

      insert_into_file "config/routes.rb", after: "devise_for :users, skip: :omniauth_callbacks" do
        <<~ROUT
          ,
                controllers: { sessions: 'users/sessions'}
        ROUT
      end
    end

    def add_toggle_two_factor_action
      insert_into_file "app/controllers/admin/profiles_controller.rb", before: "\n  private" do
        <<~RUBY.indent(2)

          def toggle_two_factor
            if resource.otp_required_for_login
              resource.update(otp_required_for_login: false)
            else
              resource.update(otp_required_for_login: true, otp_secret: User.generate_otp_secret)
            end
            redirect_to action: :edit
          end
        RUBY
      end
    end

    def add_2fa_to_profile_page
      insert_into_file "app/views/admin/profiles/edit.slim", after: "= f.input :current_password, hint: 'Введите текущий пароль'\n" do
        <<~SLIM.indent(6)
          = render '2fa', resource: resource
        SLIM
      end
    end

    def add_qrcode_helper
      insert_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
        <<~RUBY.indent(2)
          def google_authenticator_qrcode(devise_resource)
            issuer = 'Forcerate'
            label = "\#{issuer}:\#{devise_resource.email}"
            data = devise_resource.otp_provisioning_uri(label, issuer: issuer)
            escaped_data = Rack::Utils.escape(data)
            url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=\#{escaped_data}"
            image_tag(url, alt: 'Google Authenticator QRCode')
          end
        RUBY
      end
    end
  end
end
