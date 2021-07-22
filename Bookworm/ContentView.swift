//
//  ContentView.swift
//  Bookworm
//
//  Created by Bruce Gilmour on 2021-07-22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>

    @State private var showingAddBook = false

    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: Text(book.title ?? "Unknown Title")) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(trailing: Button(action: {
                showingAddBook.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddBook) {
                AddBookView().environment(\.managedObjectContext, moc)
            }
        }
    }
}

struct SizeClassView: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        if sizeClass == .compact {
            return AnyView(
                VStack {
                    Text("Active size class:")
                    Text("COMPACT")
                }
                .font(.largeTitle)
            )
        } else {
            return AnyView(
                HStack {
                    Text("Active size class:")
                    Text("REGULAR")
                }
                .font(.largeTitle)
            )
        }
    }
}

struct PushButtonView: View {
    @State private var rememberMe = false

    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}
struct PushButton: View {
    let title: String
    @Binding var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct RememberMeView: View {
    @State private var rememberMe = false

    var body: some View {
        Toggle(isOn: $rememberMe.animation()) {
            Text("Remember me?")
        }
        if rememberMe {
            Text("Boo!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
