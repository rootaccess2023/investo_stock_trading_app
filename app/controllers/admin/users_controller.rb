class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @number_of_traders = User.count
    @number_of_trades = Transaction.count
    total_revenue = Transaction.sum('price * quantity') * 0.02
    @total_revenue = total_revenue.round
    if @number_of_trades > 0
      @trade_value = @total_revenue / @number_of_trades
    else
      @trade_value = 0
    end

    @users = User.all
    @user_admins = User.with_role(:admin).count
    @user_traders = User.with_role(:approved_trader).count

    @traders_by_day = User.group_by_day(:created_at).count
    @trades_by_day = Transaction.group_by_day(:created_at).count
    @revenue_by_day = Transaction.group_by_day(:created_at).sum('price * quantity * 0.025')
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
