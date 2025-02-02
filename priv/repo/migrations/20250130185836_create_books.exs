defmodule LibraryApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    # Creating the books table with specified columns
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true  # Primary key with binary ID type
      add :title, :string, null: false        # Title field, cannot be null
      add :author, :string, null: false       # Author field, cannot be null
      add :year, :integer,  null: true                      # Year field, optional
      add :isbn, :string,  null: true

      timestamps(type: :utc_datetime)         # Automatically adds created_at and updated_at timestamps
    end

    # Adding a unique index to the ISBN field to ensure no duplicates
    create unique_index(:books, [:isbn])

    # Adding an index on the author field to optimize searches by author
    create index(:books, [:author])
  end
end
