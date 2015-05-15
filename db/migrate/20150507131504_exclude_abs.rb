class ExcludeAbs < ActiveRecord::Migration
  def change
  	drop_table :AbstractRecords
  end
end
