class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.integer :volume
      t.string :data

      t.timestamps
    end
  end
end
