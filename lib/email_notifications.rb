module EmailNotifications
  extend ActiveSupport::Concern

  included do
    attr_accessible :email_addresses
    before_validation :normalize_email_addresses

    validate :check_email_addresses, :if => :email_addresses?

    scope :with_emails, -> { where 'email_addresses IS NOT NULL' }
  end

  def emails
    return [] unless email_addresses?

    email_addresses.split(', ').map(&:squish)
  end

  private

  def normalize_email_addresses
    self.email_addresses = email_addresses.split(',').map(&:squish).delete_if(&:blank?).join(', ') if email_addresses
  end

  def check_email_addresses
    invalid_emails = emails.select { |email| ValidatesEmailFormatOf::validate_email_format(email) }

    errors.add(:email_addresses, "неправильный формат: #{invalid_emails.join(', ')}") if invalid_emails.any?
  end
end
