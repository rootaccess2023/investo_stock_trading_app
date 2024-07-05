class TraderController < ApplicationController
  def dashboard
    @user = current_user
    @grouped_transactions = @user.transactions.group_by(&:symbol).map do |symbol, transactions|
      total_quantity = transactions.sum(&:quantity)
      total_amount = transactions.sum { |t| t.quantity * t.price }
      stock_name = StockListing.find_by(symbol: symbol)&.name
      { symbol: symbol, name: stock_name, total_quantity: total_quantity, total_amount: total_amount }
    end

    @transactions = Transaction.all

    @portfolio_value = @grouped_transactions.sum { |transaction| transaction[:total_amount] }
    @chart_data = @grouped_transactions.map { |transaction| [transaction[:name] || transaction[:symbol], transaction[:total_amount]] }
  end
end
