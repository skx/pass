#!/usr/bin/env bash
#
# pass flat - Password Store Extension (https://www.passwordstore.org/)
#
# Copyright (C) 2023 Steve Kemp
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
VERSION="0.1.0"

# Show our usage
cmd_flat_usage() {
  cat <<-_EOF
Usage:

    $PROGRAM flat
       Show the contents of the password-store as a flat list of files.
       This makes grepping easy, and removes the use of colours.

       Files are show as they would be used, stripped of the prefix, and
       with the .gpg suffix removed.
_EOF
  exit 0
}


# Show our version
cmd_flat_version() {
  echo $VERSION
  exit 0
}

# Show the contents
cmd_flat() {

    # Create a temporary file
    tmp=$(mktemp)

    # move to the store-prefix
    cd $PREFIX

    # Find all files - skipping dotfiles (i.e. .git/)
    for file in $(find . -type f -not -path '*/\.*'); do

        # strip prefix
        file=$(echo "$file" | sed -r 's/^.{2}//')

        # strip suffix
        file=$(echo "$file" | sed -r s/\.gpg$//)

        # Save the file
        echo "$file" >> $tmp
    done

    # Now sort the results, and show
    sort < $tmp
    rm $tmp
}


# Entry-point
case "$1" in
    help|--help|-h)    shift; cmd_flat_usage "$@" ;;
    version|--version) shift; cmd_flat_version "$@" ;;
    *)                        cmd_flat "$@" ;;
esac
exit 0
