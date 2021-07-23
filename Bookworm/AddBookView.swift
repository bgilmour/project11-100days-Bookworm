//
//  AddBookView.swift
//  Bookworm
//
//  Created by Bruce Gilmour on 2021-07-22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }

                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)

                        newBook.id = UUID()
                        newBook.date = Date()
                        newBook.title = title
                        newBook.author = author
                        newBook.genre = genre
                        newBook.rating = Int16(rating)
                        newBook.review = review

                        try? moc.save()

                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(hasValidDetails == false)
            }
            .navigationBarTitle("Add Book")
        }
    }

    var hasValidDetails: Bool {
        if title.trimmingCharacters(in: .whitespaces).isEmpty || author.trimmingCharacters(in: .whitespaces).isEmpty || genre.isEmpty {
            return false
        }

        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
