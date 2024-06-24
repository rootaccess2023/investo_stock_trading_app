# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Creating an Admin Account

admin_user1 = User.create!(
  email: 'adminpolo@investo.com',
  password: 'investo',
  password_confirmation: 'investo'
)

admin_user1.add_role(:admin)
admin_user1.add_role(:trader)