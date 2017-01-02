import XCPlayground
import MusicTheory
import AudioKit
import AudioKitHelper

let scale = Scale.harmonicMinor(key: .e)
let bassChannel = MTScaleOscillator(scale: scale, octave: 3)
let melodyChannel = MTScaleOscillator(scale: scale, octave: 4)

let mixer = AKMixer(bassChannel.output, melodyChannel.output)
AudioKit.output = mixer
AudioKit.start()

AKPlaygroundLoop(every: 0.1, handler: {
  bassChannel.playRandom()
  melodyChannel.playRandom()
})

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
