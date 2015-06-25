class CreateVersionIdSequence < ActiveRecord::Migration
 def up
    execute <<-SQL
      CREATE SEQUENCE version_id_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE version_id_seq;
    SQL
  end
end
