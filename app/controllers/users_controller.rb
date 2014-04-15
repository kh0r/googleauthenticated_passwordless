class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_shared_secret_reset
      redirect_to login_path, :notice => 'Email sent with further instructions.'
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end
end
