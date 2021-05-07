//   File:    SoundFontParser.swift
// Project: SystemSounds
// Package: SystemSounds
// Product: SystemSounds
//
// Created by Gene De Lisa on 5/7/21
//
// Using Swift 5.0
// Running macOS 11.3
// Github: https://github.com/genedelisa/SystemSounds
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

public enum SoundFontParserError: Error {
    case invalidSF2File(reason: String)
}

extension SoundFontParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidSF2File(message):
            return NSLocalizedString(message,
                                     comment: "")
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidSF2File:
            return NSLocalizedString("that SoundFont is invalid.",
                                     comment: "")
            
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case .invalidSF2File:
            return NSLocalizedString("check the SoundFont file.",
                                     comment: "")
        }
    }
    public var helpAnchor: String? {
        switch self {
        case .invalidSF2File:
            return NSLocalizedString("someHelpAnchor.",
                                     comment: "")
        }
    }
}
extension SoundFontParserError: CustomNSError {
    
    public static var errorDomain: String {
        return "com.rockhoppertech"
    }
    
    public var errorCode: Int {
        switch self {
        case .invalidSF2File:
            return 666
        }
    }
    
    public var errorUserInfo: [String: Any] {
        switch self {
        case .invalidSF2File:
            return [ "line": 13]
        }
    }
}
