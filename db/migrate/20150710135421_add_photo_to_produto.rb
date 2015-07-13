class AddPhotoToProduto < ActiveRecord::Migration
  def change
	create_table :p_photos do |t|
	 	t.integer    :produto_id
	 	t.string     :style
	 	t.binary     :file_contents
	 end
  end
end
