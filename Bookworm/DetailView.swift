//
//  DetailView.swift
//  Bookworm
//
//  Created by Bruce Gilmour on 2021-07-22.
//

import SwiftUI
import CoreData

struct DetailView: View {
    let book: Book

    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)

                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }

                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)

                Text("Rated on: \(formattedDate(from: book.date))")
                    .font(.subheadline)
                    .padding()

                Spacer()
            }
        }
        .navigationBarTitle(book.title ?? "Unknown Book", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                deleteBook()
            }, secondaryButton: .cancel())
        }
    }

    func deleteBook() {
        moc.delete(book)
        try? moc.save()

        presentationMode.wrappedValue.dismiss()
    }

    func formattedDate(from date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date ?? Date())
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
