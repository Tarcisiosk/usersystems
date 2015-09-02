class AddCompensadoToContacorrentes < ActiveRecord::Migration
  def change
    add_column :contacorrentes, :compensado, :string
  end
end
