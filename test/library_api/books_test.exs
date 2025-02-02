defmodule LibraryApi.BooksTest do
  use LibraryApi.DataCase

  alias LibraryApi.Books

  describe "books" do
    alias LibraryApi.Books.Book

    import LibraryApi.BooksFixtures

    @invalid_attrs %{title: nil, author: nil}
    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{title: "some title", author: "some author", year: nil, isbn: nil}

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.title == "some title"
      assert book.author == "some author"
      assert book.year == nil
      assert book.isbn == nil
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{title: "some updated title", author: "some updated author", year: nil, isbn: "updated isbn"}

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.title == "some updated title"
      assert book.author == "some updated author"
      assert book.year == nil
      assert book.isbn == "updated isbn"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end
  end

  describe "get_book_by_isbn/1" do
    test "returns the book with the given ISBN" do
      book = LibraryApi.BooksFixtures.book_fixture(isbn: "12345")
      assert Books.get_book_by_isbn("12345") == {:ok, book}
    end

    def get_book_by_isbn(isbn) do
      if is_nil(isbn) do
        {:error, "Livro não encontrado com o ISBN fornecido"}
      else
        case Repo.get_by(Book, isbn: isbn) do
          nil -> {:error, "Livro não encontrado com o ISBN fornecido"}
          book -> {:ok, book}
        end
      end
    end

    test "returns an error tuple if no book is found with the given ISBN" do
      assert Books.get_book_by_isbn("nonexistent_isbn") == {:error, "Livro não encontrado com o ISBN fornecido"}
    end

    test "returns nil if ISBN is nil" do
      assert Books.get_book_by_isbn(nil) == {:ok, nil}
    end
  end

  describe "list_books_by_author/1" do
    test "returns books by the given author" do
      author = "some author"
      book1 = LibraryApi.BooksFixtures.book_fixture(author: author)
      book2 = LibraryApi.BooksFixtures.book_fixture(author: author)
      _book3 = LibraryApi.BooksFixtures.book_fixture(author: "another author")  # Corrigido o uso de book3

      assert Books.list_books_by_author(author) == [book1, book2]
    end

    test "returns an empty list if no books are found by the given author" do
      assert Books.list_books_by_author("nonexistent author") == []
    end
  end

  describe "update_book_year/2" do
    test "updates the book's year" do
      book = LibraryApi.BooksFixtures.book_fixture(year: nil)
      new_year = 2023
      assert {:ok, %LibraryApi.Books.Book{year: ^new_year}} = Books.update_book_year(book.id, new_year)
    end

    test "allows setting year to nil" do
      book = LibraryApi.BooksFixtures.book_fixture(year: 2020)
      assert {:ok, %LibraryApi.Books.Book{year: nil}} = Books.update_book_year(book.id, nil)
    end
  end
end
