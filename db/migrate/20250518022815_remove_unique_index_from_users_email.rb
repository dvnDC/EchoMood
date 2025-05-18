class RemoveUniqueIndexFromUsersEmail < ActiveRecord::Migration[8.0]
  def change
    # Usuń istniejący unikalny indeks
    remove_index :users, :email if index_exists?(:users, :email)

    # Opcjonalnie: dodaj zwykły indeks (nieunikalny)
    add_index :users, :email unless index_exists?(:users, :email)
  end
end