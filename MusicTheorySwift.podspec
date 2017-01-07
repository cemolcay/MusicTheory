#
#  Be sure to run `pod spec lint MusicTheorySwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MusicTheorySwift"
  s.version      = "0.0.2"
  s.summary      = "A music theory library with `Note`, `Interval`, `Tone`, `Scale` and `Chord` representations in swift enums."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  MusicTheory
===

A music theory library with `Note`, `Interval`, `Tone`, `Scale` and `Chord` representations in swift enums.

Requirements
----
* Swift 3
* Xcode 8

Install
----

```
pod 'MusicTheory'
```

Usage
----

Usage is pretty straitforward. Just import the package and use directly.

```
import MusicTheory
```

### Note

- C, D♭, D, E♭, E, F, G♭, G, A♭, A, B♭ and B notes.
- Could calculate ideal frequancy based on `A4 = 440Hz` piano for given octave..
- Could calculate midi note in range of [0 - 127] for octaves [0 - 10].
- Could calculate piano key value on a 88 key piano for given octave.
- Could calculate next or previous notes for given `Interval` or `Tone`.

```
let c: Note = .c
```

### Scale

- Major, minor, harmonic minor, dorian, locrian, mixolydian, lydian, phrygian scales.
- Could create custom scale with base key and intervals like `.custom(key: .c, intervals: [.m2, .M3, .d5, .P5])`.
- Could create midi note sequance of the whole scale.
- Could create `Note`s of the scale starting from the key and going forward by intervals from there.

```
let c: Note = .c
let cMaj: Scale = .major(key: c)
```

### Chord

- Major, minor, diminished, augmented, sixth, seventh and more popular chords.
- Could create custom chord with base key and intervals like `.custom(key: .c, intervals: [.m2, .M3, .P5])`
- Could create midi note sequance of the chord.
- Could create `Note`s of the chord.

```
let c: Note = .c
let cMaj: Chord = .maj(key: c)
```

### Interval

- unison, m2, M2, m3, M3, P4, A4, d5, P5, A5, m6, M6, d7, m7, M7, A7 and P8 intervals.
- Have degree and halfsteps.
- Could create custom interval.
- Used in creation of `Scale`s and `Chord`s.

### Tone

- Halfstep, whole, oneAndHalf and custom values
- Created for alternate of `Interval` for calculating neighbour `Note`s.

### Documentation

Documentation created with jazzy, hosted on [github pages](https://cemolcay.github.io/MusicTheory/)
                   DESC

  s.homepage     = "https://github.com/cemolcay/MusicTheory"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "cemolcay" => "ccemolcay@gmail.com" }
  # Or just: s.author    = "cemolcay"
  # s.authors            = { "cemolcay" => "ccemolcay@gmail.com" }
  s.social_media_url   = "http://twitter.com/cemolcay"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/cemolcay/MusicTheory.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "MusicTheory/*.{swift}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  s.framework  = "Foundation"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
