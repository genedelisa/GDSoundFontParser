//
//  ByteArray.swift
//  SoundFontInfo
//
//  Created by Gene De Lisa on 4/6/17.
//  Copyright © 2017 Gene De Lisa. All rights reserved.
//

import Foundation

open class ByteArray {

    private var bytes: [UInt8]
    private var readIndex = 0

    public init(data: Data) {
        bytes = [UInt8](data)
    }

    public init(_ byteArray: [UInt8]) {
        bytes = byteArray
    }

    public var arrayIndex: Int {
        get {
         return readIndex
        }
        set {
            readIndex = newValue
        }
    }

    public var bytesLeft: Int {
         return bytes.count - readIndex 
    }

    public func getUInt8() -> UInt8 {
        let returnValue = bytes[readIndex]
        readIndex += 1
        return returnValue
    }

    public func getInt16() -> Int16 {
        return Int16(bitPattern: getUInt16())
    }

    public func getUInt16() -> UInt16 {

//        if endian == .big {
//            let be =
//                UInt16(bytes[readIndex]) << 8 |
//                    UInt16(bytes[readIndex + 1])
//        } else {
//
//        }

        let returnValue = UInt16(bytes[readIndex]) |
            UInt16(bytes[readIndex + 1]) << 8
        readIndex += 2
        return returnValue
    }

    public func getUInt24() -> UInt {
        var returnValue = UInt(bytes[readIndex])
        returnValue = returnValue | (UInt(bytes[readIndex + 1]) << 8)
        returnValue = returnValue | (UInt(bytes[readIndex + 2]) << 16)

//        let returnValue = UInt(bytes[readIndex]) |
//            (UInt(bytes[readIndex + 1]) << 8) |
//            (UInt(bytes[readIndex + 2]) << 16)
        readIndex += 3
        return returnValue
    }

    public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }

    public func getUInt32() -> UInt32 {
        var returnValue = UInt32(bytes[readIndex])
        returnValue = returnValue | UInt32(bytes[readIndex + 1]) << 8
        returnValue = returnValue | UInt32(bytes[readIndex + 2]) << 16
        returnValue = returnValue | UInt32(bytes[readIndex + 3]) << 24
        //        let returnValue = UInt32(bytes[readIndex]) |
        //            UInt32(bytes[readIndex + 1]) << 8 |
        //            UInt32(bytes[readIndex + 2]) << 16 |
        //            UInt32(bytes[readIndex + 3]) << 24
        readIndex += 4
        return returnValue
    }

    public func getBEUInt32() -> UInt32 {

        let bigEndianValue = bytes.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee

        readIndex += 4
        return UInt32(bigEndian: bigEndianValue)

        // let data = Data(bytes: bytes)
        // return UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
    }

    public func getInt64() -> Int64 {
        return Int64(bitPattern: getUInt64())
    }

    public func getUInt64() -> UInt64 {
        var returnValue = UInt64(bytes[readIndex])
        returnValue = returnValue | UInt64(bytes[readIndex + 1]) << 8
        returnValue = returnValue | UInt64(bytes[readIndex + 2]) << 16
        returnValue = returnValue | UInt64(bytes[readIndex + 3]) << 24
        returnValue = returnValue | UInt64(bytes[readIndex + 4]) << 32
        returnValue = returnValue | UInt64(bytes[readIndex + 5]) << 40
        returnValue = returnValue | UInt64(bytes[readIndex + 6]) << 48
        returnValue = returnValue | UInt64(bytes[readIndex + 7]) << 56

//        let returnValue = UInt64(bytes[readIndex]) |
//            UInt64(bytes[readIndex + 1]) << 8 |
//            UInt64(bytes[readIndex + 2]) << 16 |
//            UInt64(bytes[readIndex + 3]) << 24 |
//            UInt64(bytes[readIndex + 4]) << 32 |
//            UInt64(bytes[readIndex + 5]) << 40 |
//            UInt64(bytes[readIndex + 6]) << 48 |
//            UInt64(bytes[readIndex + 7]) << 56
        readIndex += 8
        return returnValue
    }

    /// read a string up to the first 0.
    /// readIndex will be incremented by numberBytes; 
    /// data between numberBytes and next readIndex will be ignored
    func readStringToZero(_ numberBytes: Int) -> String {
        if numberBytes == 0 {
            return ""
        }
        let startIndex = readIndex

        var count = 0
        var a = [UInt8]()
        while count < numberBytes {
            let byte = bytes[startIndex+count]
            if byte == 0 {
                readIndex += numberBytes
                // logger.trace("returning string of count \(count)")
                return String(bytes: a,
                              encoding: String.Encoding.ascii)!
            }
            a.append(byte)
            count += 1
        }

        readIndex += numberBytes
        let rs = String(bytes: a,
                      encoding: String.Encoding.ascii)!
        // logger.trace("nonzero s '\(rs)' count: \(a.count)")
        return rs
    }

    // inam tag might have 2 zeros at the end for alignment
    public func readToNextZero() -> [UInt8] {
        var a = [UInt8]()
        for _ in 0 ..< bytes.count {
            let b = bytes[readIndex ]
            a.append(b)
            readIndex += 1
            if b == 0 {
                if bytes[readIndex] == 0 {
                    readIndex += 1
                }
                break
            }
        }
        return a
    }

    func readString(_ numberBytes: Int) -> String {
        if numberBytes == 0 {
            return ""
        }

        let startIndex = readIndex
        readIndex += numberBytes
        if readIndex > bytes.count {
            return ""
        }
        return String(bytes: bytes[startIndex ..< readIndex],
                      encoding: String.Encoding.ascii)!
    }

    public func get4ByteString() -> String? {
        return readString(4)
    }

    public func readBytes(length: Int) -> [UInt8] {
        var a = [UInt8]()
        for _ in 0 ..< length {
            let b = bytes[readIndex]
            a.append(b)
            readIndex += 1
        }
        return a
    }

//    enum Endian {
//        case big
//        case little
//    }
//    var endian:Endian = .big

    // Reads an unsigned 16-bit integer
//    func readU16() -> UInt16 {
//        var value:UInt16 = 0
//        if endian == .big {
//            value |= getUInt8() << 8
//            value |= getUInt8() << 0
//        } else {
//            // LITTLE_ENDIAN
//            value |= getUInt8() << 0
//            value |= getUInt8() << 8
//        }
//        return value
//    }

}
