require 'faker'

admin_user1 = User.create!(
  email: 'adminpolo@investo.com',
  password: 'investo',
  password_confirmation: 'investo'
)

admin_user2 = User.create!(
  email: 'admincarloz@investo.com',
  password: 'investo',
  password_confirmation: 'investo'
)

admin_user1.add_role(:admin)
admin_user1.add_role(:approved_trader)

admin_user2.add_role(:admin)
admin_user2.add_role(:approved_trader)


(1..30).each do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    created_at: Faker::Date.between(from: '2024-07-01', to: '2024-07-11')
  )
  user.add_role(:trader)
end

puts "30 users with the role of trader have been created with random created_at dates between July 1 and July 10."

symbols = ["AAPL", "GOOGL", "MSFT", "AMZN", "TSLA"]

50.times do
  user = User.all.sample
  symbol = symbols.sample
  quantity = rand(1..100)
  price = Faker::Number.decimal(l_digits: 3, r_digits: 2)
  transaction_type = ["buy", "sell"].sample
  created_at = Faker::Date.between(from: '2024-07-01', to: '2024-07-10')

  Transaction.create!(
    user: user,
    symbol: symbol,
    quantity: transaction_type == "sell" ? -quantity : quantity,
    price: price,
    transaction_type: transaction_type,
    created_at: created_at
  )
end

puts "50 trades (either sell or buy) have been created with random dates between July 1 and July 10."