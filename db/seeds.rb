# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create(:email => "admin@textspansion.com",
                 :password => "super_secret_password",
                 :account_type => 1)
admin.save

client = admin.oauth2_clients.create(:name => "Textspansion for Android",
                                     :redirect_uri => "https://textspansion.com/oauth/android_callback")
client.save

puts client.client_id