import XCPlayground
import MusicTheory
import AudioKit
import AudioKitHelper

let chord: Chord = .min(key: .e)
let chordChannel = MTChordOscillator(chord: chord)
AudioKit.output = chordChannel.output
AudioKit.start()

AKPlaygroundLoop(every: 0.2, handler: {
  chordChannel.play()
})

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true