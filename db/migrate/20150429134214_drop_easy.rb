class DropEasy < ActiveRecord::Migration
  def change
  	drop_table :has_easy_things
  end
end
