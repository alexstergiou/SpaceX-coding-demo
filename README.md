# SpaceX-coding-demo

## Installation

[CocoaPods](http://cocoapods.org/) is used for the project external dependencies. After cloning the project, in the project folder, run the following terminal command:

```ruby
pod install
```

Then open SpaceX.xcworkspace to run the project.

## Features

- The app fetches data from https://github.com/r-spacex/SpaceX-API/tree/master/docs/v4 ( the API on the document that you provided is deprecated and it recommended using V4).
- The app displays 2 sections one with company info and the other with the launches.
- The user can filter the results, which are persisted between launches.
- When tapping on a launch item the user is presented with the available link options (youtube / article / wiki, or any combination of those; depends on the data that is returned from the API).
