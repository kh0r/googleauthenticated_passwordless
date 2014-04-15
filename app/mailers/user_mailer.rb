class UserMailer < ActionMailer::Base
  default from: 'garp@sandbox263a0b5b7d3946f1969d386023326fb7.mailgun.org'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.shared_secret_reset.subject
  #
  def shared_secret_reset(user)
      @user = user
      mail :to => user.email, :subject => 'GARP - Shared Secret Reset'
  end
end
