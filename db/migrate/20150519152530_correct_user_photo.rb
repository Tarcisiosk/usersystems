class CorrectUserPhoto < ActiveRecord::Migration
  def change
  	 create_table :photos do |t|
      t.integer    :user_id
      t.string     :style
      t.binary     :file_contents
    end
    remove_column :users, :photo_file

  end
end
