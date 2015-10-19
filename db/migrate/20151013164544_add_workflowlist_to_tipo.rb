class AddWorkflowlistToTipo < ActiveRecord::Migration
  def change
  	  add_column :tipomovimentacaos, :workflow_list, :text
  end
end
