class PhotoFileProduto < ActiveRecord::Migration
  def change
  	drop_table :p_photos
  	add_column :produtos, :photo_file_name, :string
  	add_column :produtos, :photo_content_type, :string
  	add_column :produtos, :photo_file_size, :integer
  	add_column :produtos, :photo_updated_at, :datetime

  end
end
