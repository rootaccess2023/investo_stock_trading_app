class StockListing < ApplicationRecord
    belongs_to :stock

    def self.find_name_by_symbol(symbol)
        listing = find_by(symbol: symbol)
        listing ? listing.name : 'Name not found'
    end
end