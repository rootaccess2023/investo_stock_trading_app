require 'httparty'

class Stock < ApplicationRecord
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
end
