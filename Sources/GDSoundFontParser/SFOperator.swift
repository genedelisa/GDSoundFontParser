//
//  SFOperator.swift
//  SoundFont
//
//  Created by Gene De Lisa on 4/12/17.
//  Copyright © 2017 Gene De Lisa. All rights reserved.
//

import Foundation

/*
 struct sfGenList
 {
 SFGenerator sfGenOper
 genAmountType genAmount
 }
 */

public class SFOperator {

    public static let START_ADDRS_OFFSET: Int = 0
    public static let END_ADDRS_OFFSET: Int = 1
    public static let START_LOOP_ADDRS_OFFSET: Int = 2
    public static let END_LOOP_ADDRS_OFFSET: Int = 3
    public static let START_ADDRS_COARSE_OFFSET: Int = 4
    public static let MOD_LFO_TO_PITCH: Int = 5
    public static let VIB_LFO_TO_PITCH: Int = 6
    public static let MOD_ENV_TO_PITCH: Int = 7
    public static let INITIAL_FILTER_FC: Int = 8
    public static let INITIAL_FILTER_Q: Int = 9
    public static let MOD_LFO_TO_FILTER_FC: Int = 10
    public static let MOD_ENV_TO_FILTER_FC: Int = 11
    public static let END_ADDRS_COARSE_OFFSET: Int = 12
    public static let MOD_LFO_TO_RecordLUME: Int = 13
    public static let UNUSED_1: Int = 14
    public static let CHORUS_EFFECTS_SEND: Int = 15
    public static let REVERB_EFFECTS_SEND: Int = 16
    public static let PAN: Int = 17
    public static let UNUSED_2: Int = 18
    public static let UNUSED_3: Int = 19
    public static let UNUSED_4: Int = 20
    public static let DELAY_MOD_LFO: Int = 21
    public static let FREQ_MOD_LFO: Int = 22
    public static let DELAY_VIB_LFO: Int = 23
    public static let FREQ_VIB_LFO: Int = 24
    public static let DELAY_MOD_ENV: Int = 25
    public static let ATTACK_MOD_ENV: Int = 26
    public static let HOLD_MOD_ENV: Int = 27
    public static let DECAY_MOD_ENV: Int = 28
    public static let SUSTAIN_MOD_ENV: Int = 29
    public static let RELEASE_MOD_ENV: Int = 30
    public static let KEYNUM_TO_MOD_ENV_HOLD: Int = 31
    public static let KEYNUM_TO_MOD_ENV_DECAY: Int = 32
    public static let DELAY_RecordL_ENV: Int = 33
    public static let ATTACK_RecordL_ENV: Int = 34
    public static let HOLD_RecordL_ENV: Int = 35
    public static let DECAY_RecordL_ENV: Int = 36
    public static let SUSTAIN_RecordL_ENV: Int = 37
    public static let RELEASE_RecordL_ENV: Int = 38
    public static let KEYNUM_TO_RecordL_ENV_HOLD: Int = 39
    public static let KEYNUM_TO_RecordL_ENV_DECAY: Int = 40
    public static let INSTRUMENT: Int = 41
    public static let RESERVED_1: Int = 42
    public static let KEY_RANGE: Int = 43
    public static let VEL_RANGE: Int = 44
    public static let START_LOOP_ADDRS_COARSE_OFFSET: Int = 45
    public static let KEY_NUM: Int = 46
    public static let VELOCITY: Int = 47
    public static let INITIAL_ATTENUATION: Int = 48
    public static let RESERVED_2: Int = 49
    public static let END_LOOP_ADDRS_COARSE_OFFSET: Int = 50
    public static let COARSE_TUNE: Int = 51
    public static let FINE_TUNE: Int = 52
    public static let SAMPLE_ID: Int = 53
    public static let SAMPLE_MODES: Int = 54
    public static let RESERVED3: Int = 55
    public static let SCALE_TUNING: Int = 56
    public static let EXCLUSIVE_CLASS: Int = 57
    public static let OVERRIDING_ROOT_KEY: Int = 58
    public static let UNUSED_5: Int = 59
    public static let END_OPER: Int = 60

    public static let NAMES: [String] = [
        "startAddrsOffset", "endAddrsOffset", "startLoopAddrsOffset", "endLoopAddrsOffset",
        "startAddrsCoarseOffset", "modLfoToPitch", "vibLfoToPitch", "modEnvToPitch",
        "initialFilterFc", "initialFilterQ", "modLfoToFilterFc", "modEnvToFilterFc",
        "endAddrsCoarseOffset", "modLfoToVolume", "unused1", "chorusEffectsSend",
        "reverbEffectsSend", "pan", "unused2", "unused3", "unused4", "delayModLFO",
        "freqModLFO", "delayVibLFO", "freqVibLFO", "delayModEnv", "attackModEnv",
        "holdModEnv", "decayModEnv", "sustainModEnv", "releaseModEnv", "keyNumToModEnvHold",
        "keyNumToModEnvDecay", "delayVolEnv", "attackVolEnv", "holdVolEnv", "decayVolEnv",
        "sustainVolEnv", "releaseVolEnv", "keyNumToVolEnvHold", "keyNumToVolEnvDecay",
        "instrumentID", "reserved1", "keyRange", "velRange", "startLoopAddrsCoarseOffset",
        "keyNum", "velocity", "initialAttenuation", "reserved2", "endLoopAddrsCoarseOffset",
        "coarseTune", "fineTune", "sampleID", "sampleMode", "reserved3", "scaleTuning",
        "exclusiveClass", "overridingRootKey", "unused5", "endOper"
    ]

    public var id = 0
    public var amount = 0
    public var defaultValue = 0
    public var description = ""

}
