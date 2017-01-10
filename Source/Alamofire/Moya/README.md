EVReflection/Moya
============

This is the sub specification for a Moya Response extension for EVReflection

# General information

If you have a question and don't want to create an issue, then we can [![Join the chat at https://gitter.im/evermeer/EVReflection](https://badges.gitter.im/evermeer/EVReflection.svg)](https://gitter.im/evermeer/EVReflection?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

EVReflection is used in [EVCloudKitDao](https://github.com/evermeer/EVCloudKitDao) and [EVWordPressAPI](https://github.com/evermeer/EVWordPressAPI)

In most cases EVReflection is very easy to use. Just take a look at the [YouTube tutorial](https://www.youtube.com/watch?v=LPWsQD2nxqg) or the section [It's easy to use](https://github.com/evermeer/EVReflection#its-easy-to-use). But if you do want to do non standard specific things, then EVReflection will offer you an extensive range of functionality. For more information see:

### Available extensions
There are extension available for using EVReflection with [XMLDictionairy](https://github.com/nicklockwood/XMLDictionary), [Alamofire](https://github.com/Alamofire/Alamofire) or [Moya](https://github.com/Moya/Moya) with [RxSwift](https://github.com/ReactiveX/RxSwift) or [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)

- [XML](https://github.com/evermeer/EVReflection/tree/master/Source/XML)
- [Alamofire](https://github.com/evermeer/EVReflection/tree/master/Source/Alamofire)
- [AlamofireXML](https://github.com/evermeer/EVReflection/tree/master/Source/XML)
- [Moya](https://github.com/evermeer/EVReflection/tree/master/Source/Alamofire/Moya)
- [MoyaXML](https://github.com/evermeer/EVReflection/tree/master/Source/Alamofire/Moya/XML)
- [MoyaRxSwift](https://github.com/evermeer/EVReflection/tree/master/Source/Alamofire/Moya/RxSwift)
- [MoyaReactiveCocoa](https://github.com/evermeer/EVReflection/tree/master/Source/Alamofire/Moya/ReactiveCocoa)

# Installation

## CocoaPods

```ruby
pod 'EVReflection/Moya'
```

# Advanced object mapping
This subspec can use all [EVReflection](https://github.com/evermeer/EVReflection) features like property mapping, converters, validators and key kleanup. See [EVReflection](https://github.com/evermeer/EVReflection) for more information.

# Usage

Create a class which has `EVObject` as it's base class. You could also use any `NSObject` based class and extend it with the `EVReflectable` protocol. 

```swift
import Foundation
import EVReflection

class Repository: EVObject {
  var identifier: NSNumber?
  var language: String?
  var url: String?
}
```

```swift
GitHubProvider.request(.userRepositories(username), completion: { result in

    var success = true
    var message = "Unable to fetch from GitHub"

    switch result {
    case let .success(response):
        do {
            if let repos = try response.mapArray(Repository) {
              self.repos = repos
            } else {
              success = false
            }
        } catch {
            success = false
        }
        self.tableView.reloadData()
    case let .failure(error):
        guard let error = error as? CustomStringConvertible else {
            break
        }
        message = error.description
        success = false
    }
})

```