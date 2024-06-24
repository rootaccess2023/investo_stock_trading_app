class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @number_of_traders = User.count
  end

  def approved_accounts
    @approved_traders = User.without_role(:admin).with_role(:approved_trader)
    @admin_accounts = User.with_all_roles(:admin)
  end

  def rejected_accounts
    @rejected_traders = User.with_role(:rejected_trader)
  end

  def deleted_accounts
    @deleted_traders = User.with_role(:deleted_trader)
  end
  def approve
    user = User.find(params[:id])
    user.add_role(:approved_trader)
    user.remove_role(:trader)
    redirect_to pending_accounts_admin_users_path, notice: 'User has been approved for trading.'
  end

  def reject
    user = User.find(params[:id])
    user.remove_role(:trader)
    user.add_role(:rejected_trader)
    redirect_to pending_accounts_admin_users_path, notice: 'User has been rejected for trading.'
  end

  def pending_accounts
    @traders = User.with_role(:trader)
    @admins = User.with_role(:admin)
  end

  def add_to_pending
    user = User.find(params[:id])
    user.add_role(:trader)
    user.remove_role(:rejected_trader)
    redirect_to rejected_accounts_admin_users_path, notice: 'User has been added to pending.'
  end

  def delete_account
    user = User.find(params[:id])
    user.add_role(:deleted_trader)
    user.remove_role(:approved_trader)
    redirect_to approved_accounts_admin_users_path, notice: 'User has been deleted.'
  end

  def change_role_to_admin
    user = User.find(params[:id])
    user.add_role(:admin)
    redirect_to approved_accounts_admin_users_path, notice: 'User role has been changed to Admin.'
  end

  def change_role_to_trader
    user = User.find(params[:id])
    user.remove_role(:admin)
    redirect_to approved_accounts_admin_users_path, notice: 'User role has been changed to Admin.'
  end

  private

  def require_admin
    redirect_to root_path unless current_user.has_role?(:admin)
  end
end
