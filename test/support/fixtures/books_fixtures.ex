defmodule LibraryApi.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LibraryApi.Books` context.
  """

  @doc """
  Generate a book with a unique ISBN.
  """
  def book_fixture(attrs \\ %{}) do
    isbn = attrs[:isbn] || "isbn_#{:rand.uniform(100_000)}"  

    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        isbn: isbn,
        title: "some title",
        year: 42
      })
      |> LibraryApi.Books.create_book()

    book
  end
end
