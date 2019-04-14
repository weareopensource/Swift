This includes links to knowledge and information explaining the reason for the operation and architecture of this repo. 

* **Bold** : used
* _Italic_ : not used

## Swift Links

- [libhunt](https://ios.libhunt.com/)
- [awesome-swift](https://github.com/matteocrippa/awesome-swift)
- [open-source-ios-apps](https://github.com/dkhamsing/open-source-ios-apps)

## Architecture / RP framework :construction:

#### Articles :
- [reactive-programming](https://ios.libhunt.com/categories/1356-reactive-programming)

#### Tools :
- [SwiftRex](https://github.com/SwiftRex/SwiftRex) - Swift + Redux + RxSwift = SwiftRex
- [RxAutomaton](https://github.com/inamiy/RxAutomaton) - RxSwift + State Machine, inspired by Redux and Elm
- [ReSwift](https://github.com/ReSwift/ReSwift) - Unidirectional Data Flow in Swift - Inspired by Redux
- [ReRxSwift](https://github.com/svdo/ReRxSwift) - ReRxSwift: RxSwift bindings for ReSwift
- [RxState](https://github.com/RxSwiftCommunity/RxState) - Redux implementation in Swift using RxSwift
- [RxFeedback.swift](https://github.com/NoTests/RxFeedback.swift) - operator and architecture for RxSwift
- [ReactorKit](https://github.com/ReactorKit/ReactorKit) - framework for a reactive and unidirectional Swift architecture
- [katana-swift](https://github.com/BendingSpoons/katana-swift) - A modern framework for creating iOS apps, inspired by Redux. 
- [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) - Streams of values over time
- [Render](https://github.com/alexdrone/Render) - Swift and UIKit a la React.
- [ios-architecture](https://github.com/tailec/ios-architecture) - iOS architectures - MVC, MVVM, MVVM+RxSwift, VIPER, RIBs
- [fantastic-ios-architecture](https://github.com/onmyway133/fantastic-ios-architecture) - Better ways to structure iOS apps
- [XCoordinator](https://github.com/quickbirdstudios/XCoordinator) - Powerful navigation library for iOS based on the coordinator pattern
- [CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift) - Example of Clean Architecture of iOS app using RxSwift

#### Conclusion
Store Based like MVVM (= Angular repository)
Framework ??? in reflexion

## Dependencies :arrow_up:

#### Articles :
- [pods-carthage-and-spm-swifts-package-management-dilemma](https://medium.com/@ntrupin/pods-carthage-and-spm-swifts-package-management-dilemma-7da4ec87a20c )
- [apple-swift-package-manager-a-deep-dive](https://medium.com/xcblog/apple-swift-package-manager-a-deep-dive-ebe6909a5284)
- [carthage-or-cocoapods-that-is-the-question](https://medium.com/xcblog/carthage-or-cocoapods-that-is-the-question-1074edaafbcb)

![](https://process.filestackapi.com/cache=expiry:max/khWXq2gTGSo2EWwW8mYQ)

#### Tools :
- _SPM Swift Package manager_
- **Carthage**
- _Pods_

#### Conclusion
Probably Carthage.

## Tests :rotating_light:

#### Articles :
- WIP

#### Tools :
- [Quick](https://github.com/Quick/Quick) - The Swift (and Objective-C) testing framework.
- [Nimble](https://github.com/Quick/Nimble) - A Matcher Framework for Swift and Objective-C.
- [RxBlocking](https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking) - Set of blocking operators for easy unit testing.
- [Stubber](https://github.com/devxoul/Stubber) - A minimal method stub for Swift.

#### Conclusion
WIP

## CI & .. :construction_worker: 

#### Articles :
- [creating-a-ios-app-from-scratch-part-3-travis-danger-and-fastlane](https://medium.com/cocoaacademymag/creating-a-ios-app-from-scratch-part-3-travis-danger-and-fastlane-8ac91a003c95)
- [Code-Coverage-report-with-travis-ci-coveralls-and-fastlane](https://blog.darkcl.tech/2018/03/12/Code-Coverage-report-with-travis-ci-coveralls-and-fastlane/)
- [build-distribution-automation-with-fastlane-and-travis-ci-ios](https://medium.com/practo-engineering/build-distribution-automation-with-fastlane-and-travis-ci-ios-f959dff2799f)
- [carthage-tutorial-getting-started](https://www.raywenderlich.com/416-carthage-tutorial-getting-started)

#### Tools :
- **[Travis](https://travis-ci.org)** - way to test and deploy your projects
- _[Circle](https://circleci.com)_ - way to test and deploy your projects
- **[Fastlane](https://fastlane.tools)** - App automation done right for iOS
- **[Coveralls](https://coveralls.io)** - See coverage trends emerge
- **[CodeClimate](https://codeclimate.com/dashboard)** - Get automated code coverage, complexity, duplication ..
- **[SwiftLint](https://github.com/realm/SwiftLint)** - A tool to enforce Swift style and conventions
- **[SwiftGen](https://github.com/SwiftGen/SwiftGen)** - Swift code generator for assets, storyboards, Localizable ...
- **[slather](https://github.com/SlatherOrg/slather)** - Generate test coverage reports for Xcode projects 
- _[Danger](https://danger.systems)_ - runs after your CI, automating your team's conventions 

#### Conclusion
Travis, Codeclimate, Fastlane + Slather + Coveralls, SwiftLint & SwiftGen, the goal being to stay close to the functioning of repo node / angular

## Logs :loud_sound: 

#### Articles :
- [developing-a-tiny-logger-in-swif](https://medium.com/@sauvik_dolui/developing-a-tiny-logger-in-swift-7221751628e6)
- [CocoaLumberjack CustomFormatters](https://github.com/CocoaLumberjack/CocoaLumberjack/blob/master/Documentation/CustomFormatters.md)

#### Tools :
- **[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)** - A fast & simple, yet powerful & flexible logging framework for Mac and iOS

#### Conclusion
CocoaLumberjack due to [libhunt](https://ios.libhunt.com/cocoalumberjack-alternatives)
