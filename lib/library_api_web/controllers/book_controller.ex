defmodule LibraryApiWeb.BookController do
  use LibraryApiWeb, :controller

  alias LibraryApi.Books
  alias LibraryApiWeb.BookView

  action_fallback LibraryApiWeb.FallbackController

  def create(conn, %{"book" => book_params}) do
    with {:ok, book} <- Books.create_book(book_params) do
      conn
      |> put_status(:created)
      |> put_view(BookView)
      |> render("show.json", book: book)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LibraryApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)

    end
  end


  def show(conn, %{"isbn" => isbn}) do
    with book <- Books.get_book_by_isbn!(isbn) do
      render(conn, "show.json", book: book)
    end
  end

  def by_author(conn, %{"author" => author}) do
    books = Books.list_books_by_author(author)
    render(conn, "index.json", books: books)
  end

  def update_year(conn, %{"id" => id, "year" => year}) do
    with {:ok, book} <- Books.update_book_year(id, year) do
      render(conn, "show.json", book: book)
      end
  end
end
