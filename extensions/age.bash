#!/usr/bin/env bash
# pass age - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2018 Steve Kemp
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


cd $PREFIX

(
    # Run this in a sub-shell
    for filename in $( git ls-tree -r --name-only HEAD | grep '\.gpg$'); do
        echo "$(git log -1 --format="%at %ar" -- $filename) $filename"
    done

    # This will now be sorted and shown
) | sort | sed 's/\.gpg$//' | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'

