#!/usr/bin/env bash
#
# pass env - Password Store Extension (https://www.passwordstore.org/)
#
# Copyright (C) 2021 Steve Kemp
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# []

# 0.1.0 - initial release
# 0.2.0 - added support for --exec
# 0.3.0 - "pass env version" works now
VERSION="0.3.0"

cmd_env_usage() {
  cat <<-_EOF
Usage:

    $PROGRAM env [--exec=/bin/sh] pass-name
        Treat a given password-store entry as a set of key/value pairs,
       and make them available for use as environmental variables.

    Given an entry such as:

        username: bob
        password: steve
        email: user@example.com

    The expected usage would be something like this:

        source <(pass env Company/values.development)

    This will result in the export of three variables to the environment
    \$USERNAME, \$PASSWORD, and \$EMAIL.  It is assumed entries are colon-
    seperated, and keys are upper-cased for consistency.

    If you specify the --exec argument instead of echoing the values they
    will be set in the environment and then the specified program will be
    executed directly for example:

       pass env --exec=$HOME/bin/tool.cli Company/CLI/tool-name
_EOF
  exit 0
}

cmd_env_version() {
  echo $VERSION
  exit 0
}

cmd_env_set() {

  local opts exec=""
  opts="$($GETOPT -o e: -l exec: -n "$PROGRAM" -- "$@")"
  local err=$?
  eval set -- "$opts"
  while true; do case $1 in
    --exec) exec=$2; shift; shift ;;
    --) shift; break ;;
  esac done

  [[ $err -ne 0 || $# -ne 1 ]] && die "Usage: $PROGRAM $COMMAND [-exec] pass-name"

  local path="${1%/}"
  local passfile="$PREFIX/$path.gpg"
  check_sneaky_paths "$path"
  [[ ! -f $passfile ]] && die "$path: passfile not found."

  contents=$($GPG -d "${GPG_OPTS[@]}" "$passfile")
  while read -r line; do

      # Only process lines with ": " or ":\t"
      if ( echo ${line} | grep --extended ":[ \t]" 2>/dev/null >/dev/null); then

          # Key is the first field, before the ":"
          # Make it upper-case
          key=$(echo $line | awk -F: '{print $1}' | tr "[:lower:]" "[:upper:]" )

          # Now ordinarily we could get the second-field by using
          # a similar approach:
          #
          #   awk -F: '{print $2}'
          #
          # However if the password/field contains colons then this
          # breaks.  For example:
          #
          #   Link: s3:https://example.com/#!hello
          #

          # Get the second field by deleting everything upto (inclusive) ': '
          pwd=${line#*: }
          # NB: this method allows spaces in the Notes field.

          # Empty execute?  Just echo, we assume we're being sourced.
          if [ -z "${exec}" ]; then
              echo "export ${key}=\"${pwd}\""
          else
              # Exec is set, so export the value directly
              export ${key}="${pwd}"
          fi
      fi
  done <<< "$contents"

  # Executing?  Then do so.
  if [ ! -z "${exec}" ]; then
      exec ${exec}
  fi
}

case "$1" in
    help|--help|-h)    shift; cmd_env_usage "$@" ;;
    version|--version) shift; cmd_env_version "$@" ;;
    *)                        cmd_env_set "$@" ;;
esac
exit 0
