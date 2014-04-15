class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.validates(params[:validation_code])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      redirect_to new_session_path, alert: 'Email or validation code is invalid.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out!'
  end

  private
  def session_params
    params.require(:session).permit(:email, :validation_code)
  end
end
