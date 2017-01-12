//: [Previous](@previous)

import Foundation
import MusicTheory

let allChordIntervals = ChordType.all.map({ chord in
  chord.intervals.map({ interval in
    return Float(interval.halfstep)
  })
})

let allScaleIntervals = ScaleType.all.map({ scale in
  scale.intervals.map({ interval in
    return Float(interval.halfstep)
  })
})

let allScaleNoteTypes = ScaleType.all.map({ scale in
  NoteType.all.map({ note in
    return [note: scale.intervals.map({ $0.halfstep })]
  })
})


