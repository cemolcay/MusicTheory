import Foundation

let nn = FFNN(
  inputs: 10,
  hidden: 14,
  outputs: 1,
  learningRate: 0.4,
  momentum: 0.4,
  weights: nil,
  activationFunction: .Sigmoid,
  errorFunction: .default(average: false))

//nn.train(
//  inputs: [],
//  answers: [],
//  testInputs: [],
//  testAnswers: [],
//  errorThreshold: 0.15)
