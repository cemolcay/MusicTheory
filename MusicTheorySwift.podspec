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
  s.version      = "1.0.0"
  s.summary      = "A music theory library with `Note`, `Interval`, `Tone`, `Scale` and `Chord` representations in swift enums."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
MusicTheory
===

A music theory library with `Note`, `Interval`, `Scale` and `Chord` representations in swift enums.

Requirements
----
* Swift 4+
* iOS 8.0+
* macOS 10.9+
* tvOS 9.0+
* watchOS 2.0+

Install
----

```
pod 'MusicTheorySwift'
```

Usage
----

`MusicTheory` adds a bunch of basic enums and structs that you can define pretty much any music related data. Most importants are `Note`, `Scale` and `Chord`.

### `NoteType` and `Note`

- All notes defined in `NoteType` enum.
- You can create `Note`s with `NoteType`s and octaves.
- Also, you can create `Note`s with MIDI note index.
- Notes and NoteTypes are equatable, `+` and `-` custom operators defined for making calulations easier.
- Also, there are other helper functions or properties like frequency of a note.

``` swift
let d: NoteType = .d
let c = Note(type: .c, octave: 0)
```

### `Interval`

- Intervals are halfsteps between notes.
- They are `IntegerLiteral` and you can make add/subsctract them between themselves, notes or note types.
- You can build scales or chords from intervals.
- m2, M2, m3, M3, P4, d5, P5, m6, M6, m7, M7 and P8 are predefined intervals.

### `ScaleType` and `Scale`

- `ScaleType` enum defines a lot of readymade scales.
- Also, you can create a custom scale type by `ScaleType.custom(intervals: [Interval], description: String)`
- `Scale` defines a scale with a scale type and root key.
- You can generate notes of scale in an octave range.
- Also you can generate `HarmonicField` of a scale.
- Harmonic field is all possible triad, tetrad or extended chords in a scale.

``` swift
let c: NoteType = .c
let maj: ScaleType = .major
let cMaj = Scale(type: maj, key: c)
```

### `ChordType` and `Chord`

- `ChordType` is a struct with `ChordPart`s which are building blocks of chords.
- You can define any chord existing with `ChordType`.
- Thirds, fifths, sixths, sevenths and extensions are parts of the `ChordType`.
- Each of them also structs which conforms `ChordPart` protocol.
- `Chord` defines chords with type and a root key.
- You can generate notes of chord in any octave range.
- You can generate inversions of any chord.

``` swift
let m13 = ChordType(
third: .minor,
seventh: .dominant,
extensions: [
ChordExtensionType(type: .thirteenth)
])
let cm13 = Chord(type: m13, key: .c)
```

### `Tempo` and `TimeSignature`

- Tempo is a helper struct to define timings in your music app.
- TimeSignature is number of beats in per measure and `NoteValue` of each beat.
- You can calculate notes duration in any tempo by ther `NoteValue`.
- Note value defines the note's duration in a beat. It could be whole note, half note, quarter note, 8th, 16th or 32nd note.

### Documentation

[Full documentation are here](https://cemolcay.github.io/MusicTheory/)

### Unit Tests

You can find unit tests in `MusicTheoryTests` target.
Press `⌘+U` for running tests.
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
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"


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

  s.source_files  = "Source/*.{swift}"
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
