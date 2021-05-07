#!/usr/bin/env zsh
# -*- mode: sh; sh-shell: zsh; sh-indentation: 2; sh-basic-offset: 2; coding: utf-8; -*-
# vim: ft=zsh:sw=2:ts=2:et
#
# Time-stamp: "Last Modified 2021-05-04 08:35:35 by Gene De Lisa, genedelisa"
#
#
# File:
#
# Gene De Lisa
# gene@rockhoppertech.com
# http://rockhoppertech.com/blog/
# License - http://unlicense.org
################################################################################

# -R reset zsh options
# -L options LOCAL_OPTIONS, LOCAL_PATTERNS and LOCAL_TRAPS will be set
emulate -LR zsh


autoload -Uz color-messages && color-messages
# this must be set to see the messages
ZSH_DEBUG_PRINT=t

local SETTINGS_FILE=~/.${ZSH_SCRIPT:t}rc

# the following variables can be set in the settings file
local outputdir=.
local verbose
local quiet

# https://github.com/realm/jazzy

(( $+commands[jazzy] )) ||
    {
        print "You need jazzy to be installed.";
        read "DoIt?Install jazzy via sudo gem install? Continue? [y/N] "
        if [[ "$DoIt" =~ ^[Yy]$ ]]
        then
	    print Yay! Installing.
            sudo gem install jazzy
        else
            print "Ciao"
            exit 1
        fi
    }


###############################################################################
# read variables from a config file
#
# Globals:
#
# Arguments:
#
# Outputs:
#
# Returns:
#    0 on success
#
# Usage:
#
#
###############################################################################

read_config_file() {
  [[ -n ${SETTINGS_FILE} ]] && {
    [[ $verbose == "t" ]] && color_message yellow "Using settings file ${SETTINGS_FILE}"

    [[ -f $SETTINGS_FILE ]] && {
      [[ -n $verbose ]] && color_message yellow "SETTINGS_FILE $SETTINGS_FILE Exists. Sourcing."
      . ${SETTINGS_FILE}
    } || {
      [[ -n $verbose ]] && color_message "${SETTINGS_FILE} does not exist"
    }
  }
  # for example
  [[ -n $verbose ]] && print outputdir is $outputdir
}

###############################################################################
# Print a usage message then exits.
#
# Globals:
#    none
# Arguments:
#    none
# Outputs:
#    prints to stdout
# Returns:
#    0
#
# Usage:
#    usage
#
###############################################################################

usage() {
  local usagemessage="""
Build docs via jazzy


Usage: ${ZSH_SCRIPT:t} [arguments] [filename]
Arguments:
  -h or --help           Print usage information
  -t or --trace          Debug. Turns on xtrace
  -v or --verbose        Verbose
  -d or --dir dn         Specify output directory dn for downloaded file
  -q or --quiet          Just do it and don't bother me with questions


${SETTINGS_FILE} values are overridded by these flags.

Without arguments, blah blah

See this wonderful description
${ZSH_SCRIPT:t} -h
or
${ZSH_SCRIPT:t} --help

For debugging, turn on xtrace
${ZSH_SCRIPT:t} -t
or
${ZSH_SCRIPT:t} --trace

For debugging, print info to stdout
${ZSH_SCRIPT:t} -v
or
${ZSH_SCRIPT:t} --verbose

Download to the specified directory.
${ZSH_SCRIPT:t} -d ./mydir
or
${ZSH_SCRIPT:t} --dir ./mydir

You can combine flags
turn on both trace and verbose
${ZSH_SCRIPT:t} -tv

"""
  ZSH_DEBUG_PRINT=t
  color_message yellow blue $usagemessage
  exit 0
}

###############################################################################
# Uses zparseopts to crack the command line.
#
# Globals:
#
# Arguments:
#
# Outputs:
#
# Returns:
#
#
# Usage:
#
#
###############################################################################

parse_commandline() {
  emulate -LR zsh

  # common options
  local -a help_opt verbose_opt trace_opt outdir_opt quiet_opt
  # script specific
  local -a whatever_opt


  if zparseopts -D  -E -- \
                t=trace_opt        -trace=trace_opt \
                v=verbose_opt      -verbose=verbose_opt \
                q=quiet_opt        -quiet=quiet_opt \
                h=help_opt         -help=help_opt \
                d:=outdir_opt      -dir:=outdir_opt \

  then

    [[ -n ${help_opt} ]] && {usage}
    [[ -n ${trace_opt} ]] && {
      #unsetopt local_options
      setopt xtrace
      # this option is reset upon function return
      # so, do this to make it "stick"
      trap 'setopt xtrace' EXIT
    }

    [[ -n ${verbose_opt} ]] && {
      ZSH_DEBUG_PRINT=t
      verbose=t
    }

    [[ -n ${quiet_opt} ]] && {
      quiet=t
    }

    [[ ${#outdir_opt} -ge 2 ]] && {
      # 0 is empty, 1 is -f, 2 is the file
      outputdir=${outdir_opt[2]}
      [[ -n $verbose ]] && color_message yellow blue "output directory: ${outputdir}"

      [[ ! -e ${outputdir} ]] && {mkdir $outputdir}
    }


  else
    error_message "zparseopts failed"
    return 1
  fi # zparseopts

  # the -D flag removed the options
  nonflag_args="$@"

  return 0
}


###############################################################################
# Generates the docs
#
# Globals:
#     none
#
# Arguments:
#    See usage
#
# Outputs:
#     depends on the flags!
#
# Returns:
#    0 on success
#    1 on failure
#
# Usage:
#    run_jazzy

#
###############################################################################
local author="Gene De Lisa"
local author_url="https://rockhoppertech.com/blog"
local github_url="https://github.com/genedelisa/GDSoundFontParser"
local module="GDSoundFontParser"
local readme="README.md"
local output="docs/"

run_jazzy() {
    jazzy \
	--clean \
	--author ${author} \
	--author_url ${author_url} \
	--github_url ${github_url} \
    --module ${module} \
    --swift-build-tool spm \
    --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5
	--readme ${readme} \
    --min-acl internal \
    --no-hide-documentation-coverage \
	--output ${output}

    return $?
}


###############################################################################
# The main flow
#
# Globals:
#     none
#
# Arguments:
#    See usage
#
# Outputs:
#     depends on the flags!
#
# Returns:
#    0 on success
#    1 on failure
#
# Usage:
#    main [commandLineFlags]
#    main ${@}
#
###############################################################################

main() {
  read_config_file

  parse_commandline ${@}

  run_jazzy

  return 0
}

main ${@}
return $?
