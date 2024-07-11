class TraderController < ApplicationController
  def dashboard
    @user = current_user

    @grouped_transactions = @user.transactions.group_by(&:symbol).map do |symbol, transactions|
      total_quantity = transactions.sum(&:quantity)
      next if total_quantity.zero?
      price = transactions.first.price
      total_amount = total_quantity * price
      stock_name = StockListing.find_by(symbol: symbol)&.name
      { symbol: symbol, name: stock_name, total_quantity: total_quantity, total_amount: total_amount }
    end.compact

    @transactions = Transaction.all
    @transaction_cost = @user.transactions.where(transaction_type: 'buy').sum { |t| t.quantity * t.price }

    @portfolio_value = @grouped_transactions.sum { |transaction| transaction[:total_amount] }
    @chart_data = @grouped_transactions.map { |transaction| [transaction[:name] || transaction[:symbol], transaction[:total_amount]] }

    @gains = 0
    @losses = 0

    result = calculate
    if result > 0
      @gains = result
    else
      @losses = result.abs
    end
  end

  def show
  end

  def sell_stock
    @user = current_user
    @stocks = @user.transactions.group_by(&:symbol).map do |symbol, transactions|
      total_quantity = transactions.sum(&:quantity)
      stock_name = StockListing.find_by(symbol: symbol)&.name
      { symbol: symbol, name: stock_name, total_quantity: total_quantity }
    end
  end

  def sell_transaction
    @user = current_user
    symbol = params[:symbol]
    quantity = params[:quantity].to_i
    price = params[:price].to_f

    if quantity <= 0
      flash[:error] = "Quantity must be greater than zero."
      redirect_to trader_dashboard_path notice: "Quantity must be greater than zero." and return
    end

    total_quantity = @user.transactions.where(symbol: symbol).sum(&:quantity)
    if total_quantity < quantity
      flash[:error] = "Not enough stock to sell."
      redirect_to trader_dashboard_path notice: "Not enough stock to sell." and return
    end

    Transaction.create(user: @user, symbol: symbol, quantity: -quantity, price: price, transaction_type: 'sell')
    flash[:success] = "Stock sold successfully."
    redirect_to trader_dashboard_path
  end

  private

  def calculate
    @user.transactions.where(transaction_type: 'sell').sum do |sell_transaction|
      buy_transaction = @user.transactions.where(transaction_type: 'buy', symbol: sell_transaction.symbol)
                                          .where('created_at <= ?', sell_transaction.created_at)
                                          .order(created_at: :asc)
                                          .first

      next 0 unless buy_transaction

      (sell_transaction.price - buy_transaction.price) * sell_transaction.quantity
    end
  end
end
