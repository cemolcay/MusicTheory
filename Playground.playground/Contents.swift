//: Playground - noun: a place where people can play

import Foundation
import MusicTheory

let d = Key.KeyType.d
d.key(from: -2) // b
d.key(from: -19) // f
d.key(from: 12) // b
d.key(from: 0) // d
d.key(from: 1) // e
d.key(from: 2) // f
d.key(from: -3) // a
d.key(from: -301)

let f = Key.KeyType.f
f.key(from: -3) // c
