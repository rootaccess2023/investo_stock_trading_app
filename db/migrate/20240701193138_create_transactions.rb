class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :symbol
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity, default: 1
      t.integer :user_id

      t.timestamps
    end

    add_index :transactions, :user_id
  end
end
