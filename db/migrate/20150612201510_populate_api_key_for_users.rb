require 'securerandom'
class PopulateApiKeyForUsers < ActiveRecord::Migration
  def up
  	User.all.each do |u|
  		u.api_key = SecureRandom.hex
  		u.save!
  	end
  end
  def down
  end
end
