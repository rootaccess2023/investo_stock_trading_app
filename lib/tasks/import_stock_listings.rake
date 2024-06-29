namespace :import do
    desc "Import stock listings from CSV"
    task stock_listings: :environment do
      require 'csv'

      csv_file = Rails.root.join('lib/listing_status.csv')

      CSV.foreach(csv_file, headers: true) do |row|
        StockListing.create!(
          symbol: row['symbol'],
          name: row['name'],
          asset_type: row['assetType'],
          ipoDate: row['ipoDate'],
          status: row['status']
        )
      end

      puts "Stock listings imported successfully!"
    end
end
