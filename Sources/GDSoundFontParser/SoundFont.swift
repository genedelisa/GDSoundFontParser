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

public struct SoundFont {
    var infoChunk: InfoChunk!
    
    var patchesChunk: PatchesChunk!
    
    var samplesChunk: SamplesChunk!
    
    public init(infoChunk: InfoChunk,
                patchesChunk: PatchesChunk,
                samplesChunk: SamplesChunk) {
        self.infoChunk = infoChunk
        self.patchesChunk = patchesChunk
        self.samplesChunk = samplesChunk
        
        // createLayers()
    }
    
    func getHiLoBytes(num: UInt16) -> (hi: UInt8, lo: UInt8) {
        let lo = UInt8(num & 0x00ff)
        let hi = UInt8(num >> 8)
        return (hi:hi, lo:lo)
    }
    
    //                    if gen.genOper == 43 {
    //                        let lo = UInt8(gen.genAmount & 0x00ff)
    //                        let hi = gen.genAmount >> 8
    //                        logger.debug("keyrange for \(p.name) is \(gen.genAmount)  \(lo) \(hi)")
    //                    }
    //                    if gen.genOper == 44 {
    //                        let lo = UInt8(gen.genAmount & 0x00ff)
    //                        let hi = gen.genAmount >> 8
    //
    //                        logger.debug("velrange for \(p.name) is \(gen.genAmount) \(lo) \(hi)")
    //                    }
    
    public func getPresets() -> [SFPreset] {
        var list = [SFPreset]()
        for i in 0 ..< patchesChunk.presets.count {
            let p = patchesChunk.presets[i]
            // logger.debug("preset: \(p.name) (\(p.bank):\(p.preset)) \(p.presetBagIndex)")
            list.append(p)
        }
        return list
    }
    
    mutating func createLayers() {
        
        for i in 0 ..< patchesChunk.presets.count {
            var p = patchesChunk.presets[i]
            logger.debug("preset: \(p.name) (\(p.bank):\(p.preset)) \(p.presetBagIndex)")
            
            if i + 1 < patchesChunk.presets.count {
                let beginBagIndex = Int(p.presetBagIndex)
                let nextPreset = patchesChunk.presets[i + 1]
                let endBagIndex = Int(nextPreset.presetBagIndex)
                for j in beginBagIndex ..< endBagIndex {
                    let bag = patchesChunk.presetBag[j]
                    
                    if !patchesChunk.genList.isEmpty {
                        let gen = patchesChunk.genList[Int(bag.genIndex)]
                        p.gens.append(gen)
                    }
                    
                    if !patchesChunk.modList.isEmpty {
                        let mod = patchesChunk.modList[Int(bag.modIndex)]
                        p.mods.append(mod)
                    }
                    
                }
                logger.debug("preset gens \(p.gens)")
                logger.debug("preset mods \(p.mods)")
            }
        }
        
        for i in 0 ..< patchesChunk.instruments.count {
            var instrument = patchesChunk.instruments[i]
            logger.debug("instrument: \(instrument.name) \(instrument.bagIndex)")
            
            if i + 1 < patchesChunk.instruments.count {
                let beginBagIndex = Int(instrument.bagIndex)
                let nextInstrument = patchesChunk.instruments[i + 1]
                let endBagIndex = Int(nextInstrument.bagIndex)
                for j in beginBagIndex ..< endBagIndex {
                    let bag = patchesChunk.instrumentBag[j]
                    logger.debug("gen index \(bag.genIndex)")
                    
                    if !patchesChunk.instGenList.isEmpty {
                        let gen = patchesChunk.instGenList[Int(bag.genIndex)]
                        instrument.gens.append(gen)
                    }
                    
                    if !patchesChunk.instModList.isEmpty {
                        let mod = patchesChunk.instModList[Int(bag.modIndex)]
                        instrument.mods.append(mod)
                    }
                    
                }
                logger.debug("instrument gens \(instrument.gens)")
                logger.debug("instrument mods \(instrument.mods)")
            }
        }
        
    }
}

/*
 riff 407210
 
 info
 byteArray.arrayIndex 24 chunkSize 254
 
 sdta
 byteArray.arrayIndex 286 chunkSize 403014
 
 pdta
 byteArray.arrayIndex 403308 chunkSize 3914
 
 
 */
