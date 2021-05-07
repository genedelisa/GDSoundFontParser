// File:    GDSoundFontParser.swift
// Project:
// Package: GDSoundFontParser
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
import os.log

let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "GDSoundFontParser")


// swiftlint:disable type_body_length
// swiftlint:disable file_length


/// This class will parse SoundFont 2 files.
/// Right now, it can list the presets. That's all I wanted.
/// If you want more, go ahead and fill it in.
public class GDSoundFontParser: NSObject {
    var data: Data?
    
    var currentReadIndex = 0
    
    var byteArray: ByteArray!
    
    var infoChunk = InfoChunk()
    
    var patchesChunk = PatchesChunk()
    
    var samplesChunk = SamplesChunk()

    var skipReadingSamples = true
    
    public func parse(d: Data) throws -> SoundFont {
        logger.trace("\(#function)")
        
        byteArray = ByteArray(data: d)
        
        try readHeader()
        readListChunk()
        readListChunk()
        readListChunk()
        
        let soundFont = SoundFont(infoChunk: infoChunk, patchesChunk: patchesChunk, samplesChunk: samplesChunk)
        
        #if false
        if let s = infoChunk.bankName {
            logger.debug("bankName \(s)")
        }
        if let s = infoChunk.version {
            logger.debug("version \(s.wMajor):\(s.wMinor)")
        }
        if let s = infoChunk.engine {
            logger.debug("engine \(s)")
        }
        if let s = infoChunk.romName {
            logger.debug("romName \(s)")
        }
        if let s = infoChunk.romVersion {
            logger.debug("romVersion \(s)")
        }
        
        if let s = infoChunk.creationDateString {
            logger.debug("creationDateString \(s)")
        }
        if let s = infoChunk.engineerName {
            logger.debug("engineerName \(s)")
        }
        if let s = infoChunk.product {
            logger.debug("product \(s)")
        }
        if let s = infoChunk.copyright {
            logger.debug("copyright \(s)")
        }
        if let s = infoChunk.comments {
            logger.debug("comments \(s)")
        }
        if let s = infoChunk.tools {
            logger.debug("tools \(s)")
        }
        logger.debug("\(patchesChunk.presets.count) presets")
        logger.debug("\(patchesChunk.instruments.count) instruments")
        logger.debug("\(patchesChunk.sampleHeaders.count) samples")
        
        for i in patchesChunk.presets {
            logger.debug("preset: \(i.name) bank \(i.bank) preset \(i.preset)")
        }
        
        for i in patchesChunk.instruments {
            logger.debug("instrument: \(i.name) \(i.bagIndex)")
        }
        
        for s in patchesChunk.sampleHeaders {
            logger.debug("sampleHeader: \(s.name) \(s.sampleLink)")
        }
        #endif
        
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
        
        return soundFont
    }
    
    public func parse(filename: String, ext: String) throws -> SoundFont {
        logger.trace("\(#function)")
        
        let bundle = Bundle(for: self.classForCoder)
        
        guard let fileURL = bundle.url(forResource: filename, withExtension: ext) else {
            throw SoundFontParserError.invalidSF2File(reason: "Could not load soundfont \(filename).\(ext)")
        }
        
        do {
            data = try Data(contentsOf: fileURL, options: .alwaysMapped)
            if let d = data {
                return try parse(d: d)
            }
            throw SoundFontParserError.invalidSF2File(reason: "could not read data")
        } catch {
            logger.error("error: \(error.localizedDescription)")
            
            throw SoundFontParserError.invalidSF2File(reason: error.localizedDescription)
        }
    }
    
    public func parse(fileURL: URL) throws -> SoundFont {
        logger.trace("\(#function)")
        
        do {
            data = try Data(contentsOf: fileURL, options: .alwaysMapped)
            if let d = data {
                return try parse(d: d)
            }
            throw SoundFontParserError.invalidSF2File(reason: "could not read data")
        } catch {
            logger.error("error: \(error.localizedDescription)")
            
            throw SoundFontParserError.invalidSF2File(reason: error.localizedDescription)
        }
    }
    
    func readHeader() throws {
        logger.trace("\(#function)")
        
        let s = byteArray.get4ByteString()
        logger.trace("s '\(s ?? "")'")
        let chunkSize = byteArray.getInt32()
        logger.trace("RIFF chunkSize \(chunkSize)")
        let s2 = byteArray.get4ByteString()
        logger.trace("s2 '\(s2 ?? "")'")
        
        if s != "RIFF" {
            logger.error("not a RIFF")
            throw SoundFontParserError.invalidSF2File(reason: "RIFF missing")
        }
        
        if s2 != "sfbk" {
            logger.error("missing sfbk")
            throw SoundFontParserError.invalidSF2File(reason: "sfbk missing")
        }
    }
    
    // swiftlint:disable function_body_length
    func readListChunk() {
        logger.trace("\(#function)")
        
        let s = byteArray.get4ByteString()
        let chunkSize = byteArray.getInt32()
        logger.trace("list chunkSize \(chunkSize)")
        let s2 = byteArray.get4ByteString()
        if s != "LIST" {
            logger.error("not a LIST")
        }
        logger.trace("s2 \(s2 ?? "")")
        
        if s2 == "INFO" {
            logger.trace("info block")
            
            // while something
            logger.trace("byteArray.arrayIndex \(self.byteArray.arrayIndex) chunkSize \(chunkSize)")
            while byteArray.arrayIndex < Int(chunkSize) {
                
                let s3 = byteArray.get4ByteString()!
                logger.trace("s3 '\(s3)'")
                
                switch s3 {
                case "ifil":
                    // let size = byteArray.getInt32()
                    // logger.trace("got ifil: version \(size)")
                    
                    let major = byteArray.getUInt16()
                    let minor = byteArray.getUInt16()
                    // logger.trace("major \(major)")
                    // logger.trace("minor \(minor)")
                    
                    let vt = SFVersionTag(major: major, minor: minor)
                    infoChunk.version = vt
                    
                case "isng" :
                    let size = byteArray.getInt32()
                    logger.trace("got isng: sound engine \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("isng:'\(str)'")
                    
                    infoChunk.engine = str
                    
                case "irom" :
                    let size = byteArray.getInt32()
                    logger.trace("got irom:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.romName = str
                    
                case "iver" :
                    let size = byteArray.getInt32()
                    logger.trace("got iver: \(size)")
                    
                    let major = byteArray.getUInt16()
                    let minor = byteArray.getUInt16()
                    logger.trace("iver major \(major)")
                    logger.trace("iver minor \(minor)")
                    
                    let vt = SFVersionTag(major: major, minor: minor)
                    infoChunk.romVersion = vt
                    
                case "INAM" :
                    let size = byteArray.getInt32()
                    logger.trace("got INAM: bank name \(size)")
                    
                    // let str = byteArray.readStringToZero(Int(256))
                    
                    let a = byteArray.readToNextZero()
                    // logger.trace("string bytes \(a)")
                    if let sa = String(bytes: a, encoding: .ascii) {
                        logger.trace("sa '\(sa)'")
                        infoChunk.bankName = sa
                    } else {
                        logger.error("could not create string from \(a)")
                    }
                    
                case "ICRD" :
                    let size = byteArray.getInt32()
                    logger.trace("got ICRD:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.creationDateString = str
                    
                case "IENG" :
                    let size = byteArray.getInt32()
                    logger.trace("got IENG:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.engineerName = str
                    
                case "IPRD" :
                    let size = byteArray.getInt32()
                    logger.trace("got IPRD:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.product = str
                    
                case "ICOP" :
                    let size = byteArray.getInt32()
                    logger.trace("got ICOP:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.copyright = str
                    
                case "ICMT" :
                    let size = byteArray.getInt32()
                    logger.trace("got ICMT:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.comments = str
                    
                case "ISFT" :
                    let size = byteArray.getInt32()
                    logger.trace("got ISFT:  \(size)")
                    let str = byteArray.readString(Int(size))
                    logger.trace("value:'\(str)'")
                    infoChunk.tools = str
                    
                default:
                    logger.trace("unhandled \(s ?? "unknown")")
                    
                }
            }
            
        } else if s2 == "sdta" {
            
            logger.trace("samples")
            logger.trace("byteArray.arrayIndex \(self.byteArray.arrayIndex) chunkSize \(chunkSize)")

            
            while byteArray.arrayIndex < Int(chunkSize) {
                
                let s3 = byteArray.get4ByteString()!
                logger.trace("s3 '\(s3)'")
                switch s3 {
                case "smpl":
                    let numberOfSamples = byteArray.getInt32()
                    logger.trace("numberOfSamples \(numberOfSamples)")
                    if skipReadingSamples {
                        byteArray.arrayIndex += Int(numberOfSamples)
                    } else {
                        let samples = byteArray.readBytes(length: Int(numberOfSamples))
                        logger.trace("samples count \(samples.count)")
                    }
                    
                case "sm24":
                    let size = byteArray.getInt32()
                    logger.trace("samples24 \(size)")

                    if skipReadingSamples {
                        byteArray.arrayIndex += Int(size)
                    } else {
                        let samples = byteArray.readBytes(length: Int(size))
                        logger.trace("samples count \(samples.count)")
                    }
                    
                default:
                    logger.trace("unhandled \(s ?? "unknown")")
                    
                }
            }
            
        } else if s2 == "pdta" {
            logger.trace("patches")
            logger.trace("byteArray.arrayIndex \(self.byteArray.arrayIndex) chunkSize \(chunkSize)")
            
            let bindex = byteArray.arrayIndex + Int(chunkSize)
            logger.trace("pdta bindex (size) \(bindex)")
            
            var sizeRead = 0
            var numPresets = 0
            
            while byteArray.arrayIndex < bindex {
                
                let s3 = byteArray.get4ByteString()!
                logger.trace("s3 '\(s3)' at \(self.byteArray.arrayIndex)")
                
                switch s3 {
                case "phdr":
                    let size = byteArray.getInt32()
                    logger.trace("patch header \(size)")
                    
                    //                    let a = byteArray.readToNextZero()
                    //                    logger.error("string bytes \(a)")
                    //                    if let sa = String(bytes: a, encoding: .ascii) {
                    //                        logger.trace("sa '\(sa)'")
                    //                    } else {
                    //                        logger.error("could not create string from \(a)")
                    //                    }
                    
                    while sizeRead < Int(size) {
                        
                        let str = byteArray.readStringToZero(Int(20)) // 403316
                        // logger.trace("value:'\(str)'")
                        
                        // logger.trace("arrayIndex:'\(byteArray.arrayIndex)'")
                        // logger.trace("sizeRead: \(sizeRead) size \(size)")
                        
                        let preset = byteArray.getUInt16() // 403326
                        
                        let bank = byteArray.getUInt16()
                        
                        let presetBagIndex = byteArray.getUInt16()
                        
//                        logger.trace("preset \(preset)")
//                        logger.trace("bank \(bank)")
//                        logger.trace("presetBagIndex \(presetBagIndex)")
                        
                        let library = byteArray.getUInt32()
                        
                        let genre = byteArray.getUInt32()
                        
                        let morphology = byteArray.getUInt32()
                        
//                        logger.trace("library \(library)")
//                        logger.trace("genre \(genre)")
//                        logger.trace("morphology \(morphology)")
                        
                        if str != "EOP" {
                            var p = SFPreset()
                            p.name = str
                            p.preset = preset
                            p.bank = bank
                            p.presetBagIndex = presetBagIndex
                            p.library = library
                            p.genre = genre
                            p.morphology = morphology
                            patchesChunk.presets.append(p)
                        }
                        
                        if str == "EOP" {
                            logger.trace("done with the pdhr")
                            break
                        }
                        numPresets += 1
                        // logger.trace("numPresets: \(numPresets) ")
                        
                        sizeRead += 38
                    }
                    
                case "pbag":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") // 403814
                    let size = byteArray.getInt32()
                    logger.trace("pbag \(size)")
                    let zones = size / 4
                    //                    for zone in 0 ..< numPresets {
                    for zone in 0 ..< zones {
                        
                        let genIndex = byteArray.getUInt16()
                        let modIndex = byteArray.getUInt16()
//                        logger.trace("zone \(zone)")
//                        logger.trace("genIndex \(genIndex)")
//                        logger.trace("modIndex \(modIndex)")
                        let presetBag = SFPresetBag(gen: genIndex, mod: modIndex)
                        patchesChunk.presetBag.append(presetBag)
                    }
                    
                case "pmod":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") // 403874
                    
                    let size = byteArray.getInt32()
                    logger.trace("pmod \(size)")
                    
                    let nmods = size / 10
                    logger.trace("nmods \(nmods)")
                    
                    for mod in 0 ..< nmods {
                        let sfModSrcOper = byteArray.getUInt16()
                        let sfModDestOper = byteArray.getUInt16()
                        let modAmount = byteArray.getUInt16()
                        let sfModAmtSrcOper = byteArray.getUInt16()
                        let sfModTransOper = byteArray.getUInt16()
                        
                        let modList = SFModList(srcOper: sfModSrcOper,
                                                destOper: sfModDestOper,
                                                amount: modAmount,
                                                amtSrcOper: sfModAmtSrcOper,
                                                transOper: sfModTransOper)
                        patchesChunk.modList.append(modList)
                        
                        logger.trace("mod \(mod)")
//                        logger.trace("sfModSrcOper \(sfModSrcOper)")
//                        logger.trace("sfModDestOper \(sfModDestOper)")
//
//                        logger.trace("modAmount \(modAmount)")
//                        logger.trace("sfModAmtSrcOper \(sfModAmtSrcOper)")
//                        logger.trace("sfModTransOper \(sfModTransOper)")
                    }
                    
                    //
                    
                case "imod":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    
                    let size = byteArray.getInt32()
                    logger.trace("imod \(size)")
                    
                    let n = size / 10
                    
                    for zone in 0 ..< n {
                        let sfModSrcOper = byteArray.getUInt16()
                        let sfModDestOper = byteArray.getUInt16()
                        let modAmount = byteArray.getUInt16()
                        let sfModAmtSrcOper = byteArray.getUInt16()
                        let sfModTransOper = byteArray.getUInt16()
//                        logger.trace("zone \(zone)")
//                        logger.trace("sfModSrcOper \(sfModSrcOper)")
//                        logger.trace("sfModDestOper \(sfModDestOper)")
//                        logger.trace("modAmount \(modAmount)")
//                        logger.trace("sfModAmtSrcOper \(sfModAmtSrcOper)")
//                        logger.trace("sfModTransOper \(sfModTransOper)")
                        
                        let iml = SFInstModList(srcOper: sfModSrcOper, destOper: sfModDestOper, amount: modAmount, amtSrcOper: sfModAmtSrcOper, transOper: sfModTransOper)
                        patchesChunk.instModList.append(iml)
                    }
                    
                case "pgen":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    let size = byteArray.getInt32()
                    logger.trace("pgen \(size)")
                    let numZones = size / 4
                    for zone in 0 ..< numZones {
                        //                        for zone in 0 ..< numPresets {
                        let sfGenOper = byteArray.getUInt16()
                        let genAmount = byteArray.getUInt16()
//                        logger.trace("zone \(zone)")
//                        logger.trace("sfGenOper \(sfGenOper)")
//                        logger.trace("genAmount \(genAmount)")
                        let list = SFGenList(genOper: sfGenOper, genAmount: genAmount)
                        patchesChunk.genList.append(list)
                        
                    }
                    
                    // SFGenerator sfGenOper;
                    // genAmountType genAmount;
                    
                case "igen":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    let size = byteArray.getInt32()
                    logger.trace("igen \(size)") // 1228
                    
                    let numZones = size / 4
                    logger.trace("numZones \(numZones)")
                    for zone in 0 ..< numZones {
                        let sfGenOper = byteArray.getUInt16()
                        let genAmount = byteArray.getUInt16()
//                        logger.trace("zone \(zone)")
//                        logger.trace("sfGenOper \(sfGenOper)")
//                        logger.trace("genAmount \(genAmount)")
                        let list = SFInstGenList(genOper: sfGenOper, genAmount: genAmount)
                        patchesChunk.instGenList.append(list)
                    }
                    // SFGenerator sfGenOper;
                    // genAmountType genAmount;
                    
                case "inst":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    let size = byteArray.getInt32()
                    logger.trace("inst \(size)")
                    
                    let numInstruments = size / 22
                    logger.trace("numInstruments \(numInstruments)")
                    for instrument in 0 ..< numInstruments {
                        //                        for zone in 0 ..< numPresets {
                       // logger.trace("instrument \(instrument)")
                        
                        let achInstName = byteArray.readStringToZero(Int(20)) //
                        // logger.trace("name:'\(achInstName)'")
                        let wInstBagNdx = byteArray.getUInt16()
                        // logger.trace("wInstBagNdx:'\(wInstBagNdx)'")
                        if achInstName == "EOI" {
                            break
                        }
                        let inst = SFInst(name: achInstName, bagIndex: wInstBagNdx)
                        patchesChunk.instruments.append(inst)
                        
                    }
                    
                    // 22 bytes
                    //                    struct sfInst {
                    //                        CHAR achInstName[20];
                    //                        WORD wInstBagNdx; };
                    
                case "ibag":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") // 404114  imod at 404530
                    let size = byteArray.getInt32() // 412 = 530 - 118
                    logger.trace("ibag \(size)")
                    
                    let numZones = size / 4
                    logger.trace("numZones \(numZones)")
                    for zone in 0 ..< numZones {
                        //                        for zone in 0 ..< numPresets {
                        // logger.trace("bag zone \(zone)")
                        
                        let wInstGenNdx = byteArray.getUInt16()
                        // logger.trace("wInstGenNdx:'\(wInstGenNdx)'")
                        let wInstModNdx = byteArray.getUInt16()
                        // logger.trace("wInstModNdx:'\(wInstModNdx)'")
                        
                        let bag = SFInstBag(genIndex: wInstGenNdx, modIndex: wInstModNdx)
                        patchesChunk.instrumentBag.append(bag)
                        
                    }
                    
                    //                    struct sfInstBag {
                    //                        WORD wInstGenNdx;
                    //                        WORD wInstModNdx; };
                    
                case "shdr":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    let size = byteArray.getInt32() // 1426
                    logger.trace("shdr \(size)")
                    
                    let numSamp = size / 46
                    // the struct is 46 bytes
                    
                    // logger.trace("numSamp \(numSamp)")
                    for sample in 0 ..< numSamp {
                        //                    for sample in 0 ..< Int(numberOfSamples) {
                        // logger.trace("sample#:'\(sample)'")
                        
                        let achSampleName = byteArray.readStringToZero(Int(20)) //
                        // logger.trace("value:'\(achSampleName)'")
                        
                        let dwStart = byteArray.getUInt32()
                        // logger.trace("dwStart:\(dwStart)")
                        let dwEnd = byteArray.getUInt32()
                        // logger.trace("dwEnd:\(dwEnd)")
                        let dwStartloop = byteArray.getUInt32()
                        // logger.trace("dwStartloop:\(dwStartloop)")
                        let dwEndloop = byteArray.getUInt32()
                        // logger.trace("dwEndloop:\(dwEndloop)")
                        
                        let dwSampleRate = byteArray.getUInt32()
                        // logger.trace("dwSampleRate:\(dwSampleRate)")
                        
                        let byOriginalPitch = byteArray.getUInt8()
                        // logger.trace("byOriginalPitch:\(byOriginalPitch)")
                        
                        let chPitchCorrection = byteArray.getUInt8()
                        // logger.trace("chPitchCorrection:\(chPitchCorrection)")
                        
                        let wSampleLink = byteArray.getUInt16()
                        // logger.trace("wSampleLink:\(wSampleLink)")
                        
                        let sfSampleType = byteArray.getUInt16()
                        // logger.trace("sfSampleType:\(sfSampleType)")
                        
                        if achSampleName == "EOS" {
                            logger.trace("found end")
                            logger.trace("arrayIndex after reading eos block:'\(self.byteArray.arrayIndex)'")
                            break
                        }
                        
                        let slink = SFSampleLink(rawValue: sfSampleType)!
                        
                        let sample = SFSample(name: achSampleName, start: dwStart, end: dwEnd, startloop: dwStartloop, endloop: dwEndloop, sampleRate: dwSampleRate, originalKey: byOriginalPitch, correction: chPitchCorrection, sampleLink: wSampleLink, sampleType: slink)
                        
                        patchesChunk.sampleHeaders.append(sample)
                        
                    }
                    
                case "EOS":
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    let size = byteArray.getInt32()
                    logger.trace("EOS \(size)")
                    
                default:
                    logger.trace("arrayIndex:'\(self.byteArray.arrayIndex)'") //
                    logger.trace("unhandled '\(s3)'")
                    
                }
            }
            
        } else {
            logger.trace("wtf? '\(s2 ?? "")'")
        }
        
    }
    
    //    case "smpl" :
    //    logger.trace("got : ")
    //
    //    case "phdr" :
    //    logger.trace("got : ")
    //    case "pbag" :
    //    logger.trace("got : ")
    //    case "pmod" :
    //    logger.trace("got : ")
    
}
