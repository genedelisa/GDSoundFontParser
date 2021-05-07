# GDSoundFontParser



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
[![Contributors][contributors-shield]][contributors-url]
[![Build Status][build-status-shield]][build-status-url]
-->

[![MIT License][license-shield]][license-url]
[![Stargazers][stars-shield]][stars-url]
[![Forks][forks-shield]][forks-url]
[![Issues][issues-shield]][issues-url]

[![Platforms][platforms-ios-shield]][platforms-ios-url]
[![Swift 5][swift5-shield]][swift5-url]

[![Sponsors][sponsors-shield]][sponsors-url]



## Table of Contents
  * [Summary](#summary)
  * [Blog post](#blog-post-for-this-example)
  * [Usage](#usage)
  * [Issues](#issues)
  * [Licensing](#licensing)
  * [Credits](#credits)


## Summary

This is a Swift package for parsing SoundFonts

[Project Documentation][github-pages]


## Blog post for this example

[Blog post][blog-post-url]


## Usage
Read the blog post. 
Or just read the code.
Or run the tests.

e.g. Listing the preset names

```swift
import GDSoundFontParser

func getPresets() {
    let parser = GDSoundFontParser()
    let sf: SoundFont
    
    guard let fileURL = Bundle.module.url(forResource: "FreeFont", withExtension: "sf2") else {
        return
    }
    do {
        sf = try parser.parse(fileURL: fileURL)
        
        let presets = sf.getPresets()

        for p in presets {
            print("\(p.name) (\(p.bank):\(p.preset)) \(p.presetBagIndex)")
        }
    } catch {
        print("\(error.localizedDescription)")
    }
}
```

## Issues


If you find one, please add it to [Issues][issues-url]


### Buy my kitty Giacomo some cat food

[![Paypal][paypal-img]][paypal-url] 

<img src="http://www.rockhoppertech.com/blog/wp-content/uploads/2016/07/momocoding-1024.png" alt="Giacomo Kitty" width="400" height="300">


## Licensing

[MIT License article on Wikipedia][MIT-license-wiki-url]

Please read the [LICENSE](LICENSE) for details.

## Credits

[Gene De Lisa's development blog](http://rockhoppertech.com/blog/)

[Gene De Lisa's music blog](http://genedelisa.com/)

[![Twitter @GeneDeLisaDev][twitter-shield]][twitter-url]

[![LinkedIn][linkedin-shield]][linkedin-url] 

[![Stackoverflow][stackoverflow-shield]][stackoverflow-url] 



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/genedelisa/GDSoundFontParser.svg?style=flat
[contributors-url]: https://github.com/genedelisa/GDSoundFontParser/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/genedelisa/GDSoundFontParser.svg?style=flat
[forks-url]: https://github.com/genedelisa/GDSoundFontParser/network/members

[stars-shield]: https://img.shields.io/github/stars/genedelisa/GDSoundFontParser.svg?style=flat
[stars-url]: https://github.com/genedelisa/GDSoundFontParser/stargazers

[issues-shield]: https://img.shields.io/github/issues/genedelisa/GDSoundFontParser.svg?style=flat
[issues-url]: https://github.com/genedelisa/GDSoundFontParser/issues

[downloads-shield]:https://img.shields.io/github/downloads/genedelisa/GDSoundFontParser/total
[downloads-url]: https://github.com/genedelisa/GDSoundFontParser/releases/

[license-shield]: https://img.shields.io/github/license/genedelisa/GDSoundFontParser.svg?style=flat
[license-url]: https://github.com/genedelisa/GDSoundFontParser/blob/main/LICENSE


[MIT-license-wiki-url]:https://en.wikipedia.org/wiki/MIT_License

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-blue.svg?style=for-the-badge&logo=linkedin
[linkedin-url]: https://linkedin.com/in/genedelisa

[sponsors-shield]:https://img.shields.io/badge/Sponsors-Rockhopper%20Technologies-orange.svg?style=flat
[sponsors-url]:https://rockhoppertech.com/

[twitter-shield]:https://img.shields.io/twitter/follow/GeneDeLisaDev.svg?style=social
[twitter-url]: https://twitter.com/GeneDeLisaDev

[build-status-shield]:https://travis-ci.org/genedelisa/GDSoundFontParser.svg
[build-status-url]:https://travis-ci.org/genedelisa/GDSoundFontParser
[travis-status-url]:https://img.shields.io/travis/com/genedelisa/GDSoundFontParser?style=for-the-badge
[circleci-status-url]:https://img.shields.io/circleci/build/github/genedelisa/GDSoundFontParser

[github-tag-shield]:https://img.shields.io/github/tag/genedelisa/GDSoundFontParser.svg
[github-tag-url]:https://github.com/genedelisa/GDSoundFontParser/

[github-release-shield]:https://img.shields.io/github/release/genedelisa/GDSoundFontParser.svg
[github-release-url]:https://github.com/genedelisa/GDSoundFontParser/

[github-version-shield]:https://badge.fury.io/gh/genedelisa%2FGDSoundFontParser
[github-version-url]:https://github.com/genedelisa/GDSoundFontParser

[github-last-commit]:https://img.shields.io/github/last-commit/genedelisa/GDSoundFontParser

[github-issues]:https://img.shields.io/github/issues-raw/genedelisa/GDSoundFontParser
[github-closed-issues]:https://img.shields.io/github/issues-closed-raw/genedelisa/GDSoundFontParser

[github-stars-shield]:https://img.shields.io/github/stars/genedelisa/GDSoundFontParser.svg?style=social&label=Star&maxAge=2592000
[github-stars-url]:https://github.com/genedelisa/GDSoundFontParser/stargazers/

[swift5-shield]:https://img.shields.io/badge/swift5-compatible-4BC51D.svg?style=flat
[swift5-url]:https://developer.apple.com/swift

[platforms-ios-shield]:https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat
[platforms-ios-url]:https://swift.org/

[platforms-macos-shield]:https://img.shields.io/badge/Platforms-macOS-lightgray.svg?style=flat
[platforms-macos-url]:https://swift.org/

[platforms-osx-shield]:https://img.shields.io/badge/Platforms-OS%20X-lightgray.svg?style=flat
[platforms-osx-url]:https://swift.org/

[paypal-img]:https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif
[paypal-url]:https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=F5KE9Z29MH8YQ&bnP-DonationsBF:btn_donate_SM.gif:NonHosted

[stackoverflow-blah-shield]:https://img.shields.io/badge/stackoverflow-lightgray.svg?style=flat
[stackoverflow-shield]:https://stackoverflow-badge.vercel.app/?userID=409891
[stackoverflow-url]:https://stackoverflow.com/users/409891/gene-de-lisa

[blog-post-url]:http://www.rockhoppertech.com/blog/soundfont-parser/

[github-pages]:https://genedelisa.github.io/GDSoundFontParser/


