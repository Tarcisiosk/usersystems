class CorrectPhotoVNames < ActiveRecord::Migration
  def change
  	rename_column :produtos, :photo_file_name, :p_photo_file_name
  	rename_column :produtos, :photo_content_type, :p_photo_content_type
  	rename_column :produtos, :photo_file_size, :p_photo_file_size
  	rename_column :produtos, :photo_updated_at, :p_photo_updated_at

  end
end
