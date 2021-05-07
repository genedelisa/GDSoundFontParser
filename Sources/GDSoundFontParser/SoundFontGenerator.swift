// File:    File.swift
// Project: 
// Package: 
// Product: 
//
// Created by Gene De Lisa on 5/7/21
//
// Using Swift 5.0
// Running macOS 11.3
// Github: https://github.com/genedelisa/
// Product: https://rockhoppertech.com/
//
// Copyright © 2021 Rockhopper Technologies, Inc. All rights reserved.
//
// Licensed under the MIT License (the "License");
//
// You may not use this file except in compliance with the License.
//
// You may obtain a copy of the License at
//
// https://opensource.org/licenses/MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS O//R
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  
  

import Foundation

public struct SoundFontGenerator {
    
    let startAddrsOffset = 0
    let endAddrsOffset = 1
    let startloopAddrsOffset  = 2
    let endloopAddrsOffset = 3
    let startAddrsCoarseOffset = 4
    let modLfoToPitch = 5
    let vibLfoToPitch = 6
    let modEnvToPitch = 7
    let initialFilterFc = 8
    let initialFilterQ = 9
    let modLfoToFilterFc = 10
    let modEnvToFilterFc = 11
    let endAddrsCoarseOffset = 12
    let modLfoToVolume = 13
    let chorusEffectsSend = 15
    let reverbEffectsSend = 16
    let pan = 17
    let delayModLFO = 21
    let freqModLFO = 22
    let delayVibLFO = 23
    let freqVibLFO = 24
    let delayModEnv = 25
    let attackModEnv = 26
    let holdModEnv = 27
    let sustainModEnv = 29
    let releaseModEnv = 30
    let keynumToModEnvHold  = 31
    let keynumToModEnvDecay  = 32
    let delayV = 33
    let attackV = 34
    let holdV = 35
    let decayV = 36
    let sustainV = 37
    let releaseV = 38
    let keynumToVolEnvHold = 39
    let keynumToVolEnvDecay = 40
    let keyRange = 43
    let velRange = 44
    let startloopAddrsCoarseOffset = 45
    let keynum = 46
    let velocity = 47
    let initialAttenuation = 48
    let endloopAddrsCoarseOffset = 50
    let coarseTune = 51
    let fineTune = 52
    let sampleModes = 54
    let scaleTuning = 56
    let exclusiveClass = 57
    let overridingRootKey = 58
    
}
