[![Build Status](https://badges.weareopensource.me/travis/weareopensource/Swift.svg?style=flat-square)](https://app.travis-ci.com/github/weareopensource/Swift) [![Coveralls Status](https://badges.weareopensource.me/coveralls/github/weareopensource/Swift.svg?style=flat-square)](https://coveralls.io/github/weareopensource/Swift) [![Code Climate](https://badges.weareopensource.me/codeclimate/maintainability-percentage/weareopensource/Swift.svg?style=flat-square)](https://codeclimate.com/github/weareopensource/Swift/maintainability)

# :globe_with_meridians: [WeAreOpenSource](https://weareopensource.me) Swift - Beta

## :book: Presentation

This project is a Swift stack that can be ran as a standalone FrontEnd. Or in a fullstack with another repo of your choice (ex: [Node](https://github.com/weareopensource/Node), [Vue](https://github.com/weareopensource/Vue)).

Quick links :

- [Mindset and what we would like to create](https://weareopensource.me/)
- [How to start a project and maintain updates from stacks](https://blog.weareopensource.me/start-a-project-and-maintain-updates/)
- [Global roadmap and ideas about stacks](https://github.com/orgs/weareopensource/projects/3)
- [How to contribute and help us](https://blog.weareopensource.me/how-to-contribute/)

Our stack Swift is actually in Beta.

<img src="https://github.com/weareopensource/Swift/blob/master/screenshots/01.png" width="275px" /><img src="https://github.com/weareopensource/Swift/blob/master/screenshots/02.png" width="275px" /><img src="https://github.com/weareopensource/Swift/blob/master/screenshots/03.png" width="275px" />

# :computer: Swift / RxSwift / ReactorKit

- [Swift wiki](https://github.com/weareopensource/Swift/blob/master/WIKI.md) - wip
- [**Knowledges Swift**](https://blog.weareopensource.me/swift-knwoledges/)
- [**Demo**] Follow Instalation Guide (working with [Node](https://github.com/weareopensource/Node) stack, email: *test@waos.me*, password: _TestWaos@2019_)

## :package: Technology Overview

| Subject            | Informations                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Available**      |
| Architecture       | Layered Architecture : everything is separated in layers, and the upper layers are abstractions of the lower ones, that's why every layer should only reference the immediate lower layer (vertical modules architecture with Services Pattern))                                                                                                                                                                                                                     |
| Server / DB        | Our [Node](https://github.com/weareopensource/Node) stack.                                                                                                                                                                                                                                                                                                                                                                                                           |
| Reactive           | [RxSwift](https://github.com/ReactiveX/RxSwift) - [ReactorKit](https://github.com/ReactorKit/ReactorKit) <br /> [RxOptional](https://github.com/RxSwiftCommunity/RxOptional) - [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) - [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) - [RxAppState](https://github.com/pixeldock/RxAppState)                                                                                       |
| Requests           | [Moya](https://github.com/Moya/Moya) - [Kingfisher](https://github.com/onevcat/Kingfisher) - _images, with cookie plugin_                                                                                                                                                                                                                                                                                                                                            |
| Models             | [Validator](https://github.com/adamwaite/Validator) - _Models struct & Validatable_                                                                                                                                                                                                                                                                                                                                                                                  |
| Flow               | [RxFlow](https://github.com/RxSwiftCommunity/RxFlow)                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Tools              | [SnapKit](https://github.com/SnapKit/SnapKit) - [Then](https://github.com/devxoul/Then) - [Reusable](https://github.com/AliSoftware/Reusable) - [ReusableKit](https://github.com/devxoul/ReusableKit)                                                                                                                                                                                                                                                                |
| UX                 | [Eureka](https://github.com/xmartlabs/Eureka) - [Toaster](https://github.com/devxoul/Toaster) - [FontAwesome](https://github.com/thii/FontAwesome.swift) - [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner)                                                                                                                                                                                                                                                  |
| Logs               | [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) - _LogFormatter services available_                                                                                                                                                                                                                                                                                                                                                            |
| CI                 | [Travis CI](https://travis-ci.org/weareopensource/Node) <br> [fastlane](https://github.com/fastlane/fastlane) & [Slather](https://github.com/SlatherOrg/slather)                                                                                                                                                                                                                                                                                                     |
| Linter             | [SwiftLint](https://github.com/realm/SwiftLint) - [SwiftGen](https://github.com/SwiftGen/SwiftGen)                                                                                                                                                                                                                                                                                                                                                                   |
| Developer          | [Code Climate](https://codeclimate.com/github/weareopensource/Swift) <br> [standard-version](https://github.com/conventional-changelog/standard-version) / [semantic-release](https://github.com/semantic-release/semantic-release) - [commitlint](https://github.com/conventional-changelog/commitlint) - [commitizen](https://github.com/commitizen/cz-cli) - [@weareopensource/conventional-changelog](https://github.com/weareopensource/conventional-changelog) |
| Dependencies       | [SPM](https://swift.org/package-manager/)                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **Being released** |
| Testing            | in development                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **In reflexion**   |
| wip                | ....                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

## :tada: Features Overview

#### Available

- **User** : classic register / auth or oAuth(microsoft, google) - profile management (update, avatar upload ...)
- **User data privacy** : delete all data & account - send all data by mail
- **Tasks** : list tasks - get task - add tasks - edit tasks - delete tasks
- **Uploads** : get upload stream - add upload - auto delete old via api (ex : image => kingfisher: jwt, styles, cache, or sharp via node api)

- **Notification** : example of notificaiton management

## :pushpin: Prerequisites

Make sure you have installed all of the following prerequisites on your development machine:

- Git - [Download & Install Git](https://git-scm.com/downloads)
- Xcode (10.x) - [Download & Install Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
- HomeBrew - `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
- SwiftLint - `brew update && brew install swiftlint` (`swiftlint autocorrect`)
- SwiftGen - `brew update && brew install swiftgen`

For CI :

- [install ruby for MacOs users](https://usabilityetc.com/articles/ruby-on-mac-os-x-with-rvm/)
- Fastlane & Slather - `bundle install`

## :boom: Installation

It's straightforward :

```bash
git clone https://github.com/weareopensource/swift.git && cd Swift
./carthage-build.sh --platform iOS --no-use-binaries
```

## :runner: Running Your Application

### Development

- click on play !

### Production

- in develompment

### others

- lint: `swiftlint autocorrect`
- commit : `npm run commit`
- release : `npm run release -- --first-release` **standard version, changelog, tag & choose version number : -- --release-as 1.1.1**
- release:auto : `GITHUB_TOKEN=XXXXX npm run release:auto` **semantic release, changelog, tag, release** _require repositoryUrl conf in package.json_

### Configuration

In develompment

### Notifications

- enable notifications in config/default/development.json
- Or `xcrun simctl push booted me.weareopensoruce.vue.testing example.apn` (on simulator launched)
- Or `xcrun simctl push XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX me.weareopensoruce.vue.testing example.apn` (xx => device token)
- Or drag and drop example.apns on device
- [article](https://www.raywenderlich.com/11395893-push-notifications-tutorial-getting-started)

## :pencil2: [Contribute](https://blog.weareopensource.me/how-to-contribute/)

## :scroll: History

This work is based on [MEAN.js](http://meanjs.org) and more precisely on a fork of the developers named [Riess.js](https://github.com/lirantal/Riess.js). The work being stopped we wished to take it back, we want to create updated stack with same mindset "simple", "easy to use". The toolbox needed to start projects, but not only with Node and Angular ...

## :globe_with_meridians: [We Are Open Source, Who we are ?](https://weareopensource.me)

Today, we dreams to create Backs/Fronts, aligns on feats, in multiple languages, in order to allow anyone to compose fullstack on demand (React, Angular, VusJS, Node, Nest, Swift, Go).
Feel free to discuss, share other kind of bricks, and invite whoever you want with this mindset to come help us.

Feel free to help us ! :)

## :clipboard: Licence

[![Packagist](https://badges.weareopensource.me/packagist/l/doctrine/orm.svg?style=flat-square)](/LICENSE.md)

## :link: Links

[![Blog](https://badges.weareopensource.me/badge/Read-our%20Blog-1abc9c.svg?style=flat-square)](https://blog.weareopensource.me) [![Slack](https://badges.weareopensource.me/badge/Chat-on%20our%20Slack-d0355b.svg?style=flat-square)](https://join.slack.com/t/weareopensource/shared_invite/zt-62p1qxna-PEQn289qx6mmHobzKW8QFw) [![Discord](https://badges.weareopensource.me/badge/Chat-on%20our%20Discord-516DB9.svg?style=flat-square)](https://discord.gg/U2a2vVm) [![Mail](https://badges.weareopensource.me/badge/Contact-us%20by%20mail-00a8ff.svg?style=flat-square)](mailto:brisorgueilp@gmail.com?subject=Contact)
