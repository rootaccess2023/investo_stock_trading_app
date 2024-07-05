    class StocksController < ApplicationController
      def index
        @stocks = Stock.all
        @stock_listings = StockListing.all
      end

      def show
        @stock = Stock.find(params[:id])
        @stock_listings = StockListing.find_by(symbol: @stock.symbol)

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

      def buy_stock
        @stock = Stock.find(params[:id])
        @stock_listings = StockListing.find_by(symbol: @stock.symbol)
        @transaction = Transaction.new
      end

      def buy_transaction
        @stock = Stock.find(params[:id])
        @stock_listings = StockListing.find_by(symbol: @stock.symbol)
        @transaction = Transaction.new(transaction_params.merge(
          symbol: @stock.symbol,
          price: @stock.close,
          user_id: current_user.id
        ))

        if @transaction.save
          redirect_to  trader_dashboard_path, notice: "Stock purchased successfully."
        else
          render :buy_stock
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:quantity)
      end
    end
