class Notifier < ActionMailer::Base
  default from: -> { settings.email_header_from }, to: -> { settings.email }

  private

  def settings
    Settings.get
  end
end
