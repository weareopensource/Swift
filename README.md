[![Build Status](https://badges.weareopensource.me/travis/weareopensource/Swift.svg?style=flat-square)](https://travis-ci.org/weareopensource/Swift) [![Coveralls Status](https://badges.weareopensource.me/coveralls/github/weareopensource/Swift.svg?style=flat-square)](https://coveralls.io/github/weareopensource/Swift) [![Code Climate](https://badges.weareopensource.me/codeclimate/maintainability-percentage/weareopensource/Swift.svg?style=flat-square)](https://codeclimate.com/github/weareopensource/Swift/maintainability)

# :globe_with_meridians: [WeAreOpenSource](https://weareopensource.me) Swift

## :book: Presentation

This project is a Swift stack that can be ran as a standalone FrontEnd. Or in a fullstack with another repo of your choice (ex: [Node](https://github.com/weareopensource/Node), [Vue](https://github.com/weareopensource/Vue)).

More informations about us in our [global repo](https://github.com/weareopensource/weareopensource.github.io)

Quick links :

* Mindset and what we would like to create : [introduction](https://weareopensource.me/introduction/) (in construction)
* How to create a fullstack from our repo : [global wiki](https://github.com/weareopensource/weareopensource.github.io/wiki) (in construciton).
* Global roadmap and  ideas about stacks : [board](https://github.com/weareopensource/weareopensource.github.io/projects/1)
* How to contribute and help us : [here](https://github.com/weareopensource/weareopensource.github.io/blob/master/CONTRIBUTE.md)

Our stack Swift is actually in Beta.

# :computer: Swift / RxSwift / ReactorKit

* [Swift wiki](https://github.com/weareopensource/Swift/blob/master/WIKI.md) - wip
* [Knowledges Swift](https://github.com/weareopensource/weareopensource.github.io/wiki/Knowledges-Swift)
* [**Demo**] Follow Instalation Guide (working with [Node](https://github.com/weareopensource/Node) stack, email: *test@waos.me*, password: *TestWaos@2019*)

## :package: Technology Overview

| Subject | Informations
| ------- | --------
| **in development** |
| Architecture | Layered Architecture : everything is separated in layers, and the upper layers are abstractions of the lower ones, that's why every layer should only reference the immediate lower layer (vertical modules architecture)
| Security | JWT Stateless - have a look on [Node](https://github.com/weareopensource/Node) stack for more informations
| CI  | [Travis CI](https://travis-ci.org/weareopensource/Node) <br> [fastlane](https://github.com/fastlane/fastlane) & [Slather](https://github.com/SlatherOrg/slather)
| Developer  | [Coveralls](https://coveralls.io/github/weareopensource/Swift) - [Code Climate](https://codeclimate.com/github/weareopensource/Swift) <br> [standard-version](https://github.com/conventional-changelog/standard-version) - [commitlint](https://github.com/conventional-changelog/commitlint) - [commitizen](https://github.com/commitizen/cz-cli) - [waos-conventional-changelog](https://github.com/WeAreOpenSourceProjects/) <br>  [SwiftLint](https://github.com/realm/SwiftLint) - [SwiftGen](https://github.com/SwiftGen/SwiftGen)
| Dependencies | [Carthage](https://github.com/Carthage/Carthage)
| **Being released** |
| wip  | ....
| **In reflexion** |
| wip  | ....

## :tada: Features Overview

#### Available

* **User** : classic register / auth or oAuth(microsoft, google) - profile management (update, avatar upload ...) - **data privacy ok** (delete all data, get all data, send all by mail data)
* **Tasks** : list tasks - get task - add tasks - edit tasks - delete tasks - **data privacy ok**

## :pushpin: Prerequisites

Make sure you have installed all of the following prerequisites on your development machine:

* Git - [Download & Install Git](https://git-scm.com/downloads)
* Xcode (10.x) - [Download & Install Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
* HomeBrew - `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
* Carthage - `brew update && brew install carthage`
* SwiftLint - `brew update && brew install swiftlint` (`swiftlint autocorrect`)
* SwiftGen - `brew update && brew install swiftgen`

For CI :

* [install ruby for MacOs users](https://usabilityetc.com/articles/ruby-on-mac-os-x-with-rvm/)
* Fastlane & Slather - `bundle install`

## :shipit: Installation

It's straightforward (you can use yarn if you want)

```bash
git clone https://github.com/weareopensource/swift.git && cd Swift
carthage update --platform iOS
open waosSwift.xcodeproj
```

if you have some toruble with ReactorKit :

```bash
carthage update 2>/dev/null
(cd Carthage/Checkouts/ReactorKit && swift package generate-xcodeproj)
carthage build
```

## :runner: Running Your Application

### Development

* click on play !

### Production

* in develompment

### others

* lint:  `swiftlint autocorrect`
* commit : `npm run commit`

### Configuration

In develompment

## :octocat: [Contribute](https://github.com/weareopensource/weareopensource.github.io/blob/master/CONTRIBUTE.md)

## :scroll: History

This work is based on [MEAN.js](http://meanjs.org) and more precisely on a fork of the developers named [Riess.js](https://github.com/lirantal/Riess.js). The work being stopped we wished to take it back, we want to create updated stack with same mindset "simple", "easy to use". The toolbox needed to start projects, but not only with Node and Angular ...

## :globe_with_meridians: [We Are Open Source, Who we are ?](https://weareopensource.me)

Today, we dreams to create Backs/Fronts, aligns on feats, in multiple languages, in order to allow anyone to compose fullstack on demand (React, Angular, VusJS, Node, Nest, Swift, Go).
Feel free to discuss, share other kind of bricks, and invite whoever you want with this mindset to come help us.

## :clipboard: Licence

[![Packagist](https://badges.weareopensource.me/packagist/l/doctrine/orm.svg?style=flat-square)](/LICENSE.md)

## :family: Main Team

Pierre

[![Blog](https://badges.weareopensource.me/badge/Read-WAOS%20Blog-1abc9c.svg?style=flat-square)](https://weareopensource.me) [![Slack](https://badges.weareopensource.me/badge/Chat-WAOS%20Slack-d0355b.svg?style=flat-square)](mailto:weareopensource.me@gmail.com?subject=Join%20Slack&body=Hi,%20I%20found%20your%20community%20We%20Are%20Open%20Source.%20I%20would%20be%20interested%20to%20join%20the%20Slack%20to%20share%20and%20discuss,%20Thanks) [![Mail](https://badges.weareopensource.me/badge/Contact-me%20by%20mail-00a8ff.svg?style=flat-square)](mailto:weareopensource.me@gmail.com?subject=Contact) [![Twitter](https://badges.weareopensource.me/badge/Follow-me%20on%20Twitter-3498db.svg?style=flat-square)](https://twitter.com/pbrisorgueil?lang=fr)  [![Youtube](https://badges.weareopensource.me/badge/Watch-me%20on%20Youtube-e74c3c.svg?style=flat-square)](https://www.youtube.com/channel/UCIIjHtrZL5-rFFupn7c3OtA)

Feel free to come help us ! :)
