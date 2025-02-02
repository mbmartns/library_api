defmodule LibraryApi.Repo.Migrations.AlterBooksIsbnNullable do
  use Ecto.Migration

  def change do
    alter table(:books) do
      modify :isbn, :string, null: true 
    end
  end
end
