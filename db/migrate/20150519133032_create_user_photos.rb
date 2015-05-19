class CreateUserPhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer    :user_id
      t.string     :style
      t.binary     :file_contents
    end

  end

  def self.down

    drop_table :photos

  end
end
