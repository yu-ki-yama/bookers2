# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# coding: utf-8

100.times do |n|
  User.create(
      name: "test#{n}",
      email: "test#{n}@example.com",
      password: "aaaaaa"
  )
end

100.times do |n|
  Book.create(
      title: "test#{n}",
      body: "enjoy#{n}enjoy",
      user_id: n%9+1
  )
end