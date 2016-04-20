
# Slow - Swift Rate Limiting

Easy rate limiting perfect for live search or autocomplete. The first call starts a timer, subsequent calls cancel the previous closure and starts a new timer.

## Usage

    import Slow
    
    let slow = Slow(interval: 0.25)

    // you can now call slow.run as much as you 
    for i in 0...5 {
        slow.run {
            print("\(i)")
        }
    }
    
    // only the final print (5) will run.

You can also init with a specific dispatch queue if you'd like your closures to run on that queue. Slow defaults to the main queue.

    let slow = Slow(interval: 0.25, queue: dispatch_get_main_queue())
    

## Installation

### Swift Package Manager

Add Later to your `Package.swift` file:

    import PackageDescription

    let package = Package(
        name: "YourPackageName",
        dependencies: [
            .Package(url: "https://github.com/coryalder/Slow.git", majorVersion: 0),
        ]
    )






