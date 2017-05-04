# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

alex = User.create(username: 'alex', email: 'alex@unid.com', password: '1234', password_confirmation: '1234')
ben = User.create(username: 'ben', email: 'ben@unid.com', password: '1234', password_confirmation: '1234')
devin = User.create(username: 'devin', email: 'devin@unid.com', password: '1234', password_confirmation: '1234')
parker = User.create(username: 'parker', email: 'parker@unid.com', password: '1234', password_confirmation: '1234')
sam = User.create(username: 'sam', email: 'sam@unid.com', password: '1234', password_confirmation: '1234')
