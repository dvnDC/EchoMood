module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.all
    end

    def edit
      @roles = Role.all
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Użytkownik został zaktualizowany.'
      else
        @roles = Role.all
        render :edit
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:nickname, :password, :password_confirmation, role_ids: [])
    end

    def require_admin
      unless current_user.admin?
        redirect_to root_path, alert: 'Nie masz dostępu do tej strony.'
      end
    end
  end
end