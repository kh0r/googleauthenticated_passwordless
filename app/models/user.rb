class User < ActiveRecord::Base
  validates_uniqueness_of :email

  after_create :reset_shared_secret

  validates_presence_of :email, :on => :create

  def reset_shared_secret
    self.shared_secret = ROTP::Base32.random_base32
    self.save
  end

  def qr_code_url
    data = ROTP::TOTP.new(self.shared_secret).provisioning_uri('RailsPasswordless')
    data.to_s
  end

  def validates(validation_code)
    return false if validation_code.blank?
    ROTP::TOTP.new(self.shared_secret).verify(validation_code)
  end

  def generate_reset_token
    begin
      self.reset_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_token: self.reset_token)
    # regenerate until no other user has this token - paranoid
  end

  def send_shared_secret_reset
    generate_reset_token
    self.reset_sent_at = Time.zone.now
    save!
    UserMailer.shared_secret_reset(self).deliver
  end

end
