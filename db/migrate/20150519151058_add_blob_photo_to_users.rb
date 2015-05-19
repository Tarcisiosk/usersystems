class AddBlobPhotoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :photo_file, :binary
  end
end
