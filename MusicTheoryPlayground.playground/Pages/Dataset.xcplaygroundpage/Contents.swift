import XCPlayground
import Foundation
import MusicTheory
import AudioKit
import AudioKitHelper

let scales = Dataset.generateAllScales()
let chords = Dataset.generateAllChords()

var scale = 0
var current = 0
var max = scales[current].count
var scaleMax = scales.count

let osc = MTOscillator()
AudioKit.output = osc.output
AudioKit.start()

AKPlaygroundLoop(every: 0.1, handler: {
  osc.play(midi: scales[scale][current])
  current += 1
  if current >= max {
    current = 0
    scale += 1
    if scale >= scaleMax {
      scale = 0
      max = scales[current].count
    }
  }
})

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
