require 'httparty'

class Stock < ApplicationRecord

  has_many :stock_listings, class_name: 'StockListing'

  BASE_URL = 'https://www.alphavantage.co/query'
  API_KEY = '9IFOLBEWI6DUYO27'

  def self.fetch_and_store(symbol)
    response = HTTParty.get(BASE_URL, query: {
      function: 'TIME_SERIES_DAILY',
      symbol: symbol,
      apikey: API_KEY
    })

    data = response.parsed_response["Time Series (Daily)"]
    return unless data

    stock_data = {}

    data.each do |date, values|
      stock_data[date] = {
        "4. close" => values['4. close']
      }
    end

    latest_date, latest_data = data.first
    Stock.create(
      symbol: symbol,
      open: latest_data['1. open'],
      high: latest_data['2. high'],
      low: latest_data['3. low'],
      close: latest_data['4. close'],
      volume: latest_data['5. volume'],
      data: stock_data.to_json
    )
  end

  def price_range
    high - low
  end

  def intraday_change
    close - open
  end

  def ic_percentage
    (intraday_change / open) * 100
  end

  def midpoint_price
    (high + low) / 2
  end

  def stock_price_changes
    stock_data = JSON.parse(data)

    dates = stock_data.keys.sort.reverse
    return nil if dates.size < 2

    latest_date = dates[0]
    second_latest_date = dates[1]

    latest_close = stock_data[latest_date]["4. close"].to_f
    second_latest_close = stock_data[second_latest_date]["4. close"].to_f

    latest_close - second_latest_close
  end

  def percentage_change
    stock_data = JSON.parse(data)

    dates = stock_data.keys.sort.reverse
    return nil if dates.size < 2

    latest_date = dates[0]
    second_latest_date = dates[1]

    latest_close = stock_data[latest_date]["4. close"].to_f
    second_latest_close = stock_data[second_latest_date]["4. close"].to_f

    ((latest_close - second_latest_close) / second_latest_close) * 100
  end
end
