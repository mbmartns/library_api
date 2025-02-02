defmodule LibraryApiWeb.BookController do
  use LibraryApiWeb, :controller

  alias LibraryApi.Books

  action_fallback LibraryApiWeb.FallbackController

  def create(conn, %{"book" => book_params}) do
    book_params = Map.put_new(book_params, "isbn", nil) # Garante que ISBN pode ser nulo

    case Books.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_status(:created)
        |> render("show.json", book: book)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})
    end
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def show(conn, %{"isbn" => isbn}) do
    case Books.get_book_by_isbn(isbn) do
      {:ok, book} -> render(conn, "show.json", book: book)
      {:error, _reason} -> send_resp(conn, 404, "Livro não encontrado")
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
