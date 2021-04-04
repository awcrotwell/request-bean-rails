# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authorized, only: %i[new create]
  before_action :set_user, except: :new

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to '/bins'
    else
      flash[:error] = 'Wrong username or password'
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  private

    def set_user
      @user = User.find_by_email(user_params[:email])
    end

    def user_params
      params.permit(:email, :password)
    end
end
