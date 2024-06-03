class ChangeDeseadosTypeInUsers < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE users
      ALTER COLUMN deseados TYPE text[] USING deseados::text[];
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE users
      ALTER COLUMN deseados TYPE varchar[] USING deseados::varchar[];
    SQL
  end
end
