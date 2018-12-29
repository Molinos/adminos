class Settings < ApplicationRecord
  before_validation :sanitize

  validates :company_name, :email, :email_header_from, :per_page, presence: true
  validate :check_email_header_from

  def self.get
    first || new
  end

  private

  def sanitize
    fields = [ :copyright, :email, :index_meta_description, :index_meta_title ]

    fields.each do |attribute|
      self[attribute] = Sanitize.clean self[attribute], elements: ['br']
    end
  end

  def check_email_header_from
    host = ActionMailer::Base.default_url_options[:host].split(':')[0]
    unless self.email_header_from.include?(host)
      errors.add(:email_header_from, :wrong_host, host: host)
    end
  end
end
