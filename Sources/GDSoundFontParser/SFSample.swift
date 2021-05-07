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

public struct SFSample {
    var name: String // 20
    var start: UInt32
    var end: UInt32
    var startloop: UInt32
    var endloop: UInt32
    var sampleRate: UInt32
    var originalKey: UInt8
    var correction: UInt8
    var sampleLink: UInt16
    var sampleType: SFSampleLink
    
    public init(name: String,
         start: UInt32,
         end: UInt32,
         startloop: UInt32,
         endloop: UInt32,
         sampleRate: UInt32,
         originalKey: UInt8,
         correction: UInt8,
         sampleLink: UInt16,
         sampleType: SFSampleLink) {
        
        self.name = name
        self.start = start
        self.end = end
        self.startloop = startloop
        self.endloop = endloop
        self.sampleRate = sampleRate
        self.originalKey = originalKey
        self.correction = correction
        self.sampleLink = sampleLink
        self.sampleType = sampleType
    }
}
