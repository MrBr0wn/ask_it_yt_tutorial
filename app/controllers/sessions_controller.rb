class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy
  before_action :set_user, only: :create

  def new; end

  def create
    # & - if user not found then condition equals as false
    # exception will not throw
    if @user&.authenticate(params[:password])
      do_log_in(@user)
      flash[:success] = t('.success', name: current_user.name_or_email)
      redirect_to root_path
    else
      flash.now[:warning] = 'Incorrect email/password!'
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = 'Goodbye!'
    redirect_to root_path
  end

  private

  def do_log_in(user)
    log_in(user)
    remember(user) if params[:remember_me] == '1'
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end
end
