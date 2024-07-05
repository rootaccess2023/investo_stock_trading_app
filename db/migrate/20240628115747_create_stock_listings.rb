class CreateStockListings < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_listings do |t|
      t.string :symbol
      t.string :name
      t.string :asset_type
      t.date :ipoDate
      t.string :status

      t.timestamps
    end
  end
end
