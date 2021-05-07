#!/usr/bin/env zsh
# -*- mode: sh; sh-shell: zsh; sh-indentation: 2; sh-basic-offset: 2; coding: utf-8; -*-
# vim: ft=zsh:sw=2:ts=2:et
#
# Time-stamp: "Last Modified 2021-05-04 09:49:03 by Gene De Lisa, genedelisa"
#
#
# File: run tests
#
# Gene De Lisa
# gene@rockhoppertech.com
# http://rockhoppertech.com/blog/
# License - http://unlicense.org
################################################################################

# -R reset zsh options
# -L options LOCAL_OPTIONS, LOCAL_PATTERNS and LOCAL_TRAPS will be set
emulate -LR zsh

local scheme="GDSoundFontParser"
local destination="platform=iOS Simulator,OS=14.5,name=iPad (8th generation)"

(( $+commands[xcodebuild] )) ||
    {
      print "You need xcodebuild to be installed."
    }

xcodebuild clean test \
	   -scheme ${scheme} \
	   -destination ${destination} \
	   CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO
