class User < ApplicationRecord
  attr_accessor :old_password, :remember_token

  has_secure_password validations: false

  # relationship User to questions
  has_many :questions, dependent: :destroy

  # relationship User to answers
  has_many :answers, dependent: :destroy

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validates :password, confirmation: true, allow_blank: true

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validate :password_complexity

  def remember_me
    # https://ruby-doc.org/stdlib-2.5.1/libdoc/securerandom/rdoc/Random/Formatter.html#urlsafe_base64-method
    self.remember_token = SecureRandom.urlsafe_base64

    # Insert record(hash) to the table. .digest() is a method based has_secure_password
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil
  end

  # Checking if the token matches the token from DB
  def remember_token_authenticated?(remember_token)
    return false unless remember_token_digest.authenticate?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  private

  def digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_complexity
    message = 'complexity requirement not met. Length should be 8-70 characters and' \
    'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, message
  end

  def password_presence
    return errors.add(:password, :blank) if password_digest.blank?
  end
end
