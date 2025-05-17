class AddNicknameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nickname, :string
    add_index :users, :nickname, unique: true

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE users SET nickname = substring(email from 1 for position('@' in email) - 1) WHERE nickname IS NULL;
        SQL
      end
    end

    change_column_null :users, :email, true
  end
end