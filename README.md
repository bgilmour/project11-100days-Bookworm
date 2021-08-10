# Project 11 (Bookworm)

This is my solution to the Bookworm project (project 11) in the [100 Days Of SwiftUI](https://www.hackingwithswift.com/100/swiftui/) tutorial created by Paul Hudson ([@twostraws](https://github.com/twostraws)).

Challenge 1 adds validation to the add book form to ensure that the title, author, and genre are all non empty before enabling the Save button.

Challenge 2 displays the book title using red text in the content view if the book has a one star rating.

Challenge 3 adds a date field to the Book entity in the data model. The date is displayed in the DetailView using the short date style and is provided by a computed property in the view struct. The optional nature of the date field means that books added prior to the data model change don't need to be migrated as the missing date can simply default to the current date (which is what I do in the computed date format property).

Project 15 introduced some accessibility modifiers that made the RatingView more usable by anyone using the screen reader.
