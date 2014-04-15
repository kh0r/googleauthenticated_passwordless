class SharedSecretResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_shared_secret_reset if user
    redirect_to login_path, :notice => 'Email sent with further instructions.'
  end

  def edit
    @user = User.find_by_reset_token!(params[:id])
    if @user.reset_sent_at < 2.hours.ago
      redirect_to new_shared_secret_reset_path, :alert => 'Reset has expired.'
    else
      @user.reset_shared_secret
      @qr = RQRCode::QRCode.new(@user.qr_code_url, :size => 5, :level => :q)
      render :edit
    end
  end
end
