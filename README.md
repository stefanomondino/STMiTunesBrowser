# Reactive iTunes Browser

This is a small demo where I'm trying to show the great advantages of a MVVM (Model-View-ViewModel) approach to an iOS project, thanks to the great work of the amazing ReactiveCocoa team.

Use the search view to search for a song (or an artist name, or something like that in the "music" ecosystem) and query the iTunes API for it.
Click an element to preview your tune or turn the switch on to add it to a list of bookmarks.

Behind the scenes, you can find these elements:

- a shared Model connects to the API and takes care of the queries (connection is made easier with AFNetworking)
- the response is parsed into small items. I could have used some big mapping framework like RestKit but iTunes items are so simple that wasn't worth it.
- every item is represented by a NSDictionary and every interesting property is made accessible via a readonly native method
- to persist the bookmarks, Magical Record is used (getting rid of all Core Data boilerplate code). The Core Data entry is simply made by an ID, a timestamp and a transformable object with the full dictionary (since I don't need to query Core Data for more info, I just want to list everything out sorted by date of insertion, descending).
- a table view controller lists everything out. The same view controller is used for both query and bookmarks views.
- the view model binds everything together. It acts like a bridge between view(controller) and model, so that every possible change that could be made on a single property of a model item is observed and updated if needed in the view. On top of that, the whole datasource get destroyed and rebuilt every time a new query gets executed.
- SDWebImage is used to manage remote image downloads. It gets transformed into a RACSignal and binded to every single element in the list.

## Installation

Just clone the repo and run pod install. Then open the workspace and enjoy!

For any further question or contributions contact me!
