class StocksController < ApplicationController
  def index
    @stocks = Stock.all
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def fetch_data
    Stock.fetch_and_store(params[:symbol])
    redirect_to stocks_path, notice: "Stock data fetched and stored successfully."
  end
end
