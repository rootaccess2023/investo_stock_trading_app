class StocksController < ApplicationController
  def index
    @stocks = Stock.all
  end

  def show
    @stock = Stock.find(params[:id])

    stock_data = JSON.parse(@stock.data)
    @chart_data = stock_data.map do |date, data|
      {
        name: @stock.symbol,
        data: {
          date.to_date => data["4. close"].to_f
        }
      }
    end
  end

  def fetch_data
    Stock.fetch_and_store(params[:symbol])
    redirect_to stocks_path, notice: "Stock data fetched and stored successfully."
  end
end
