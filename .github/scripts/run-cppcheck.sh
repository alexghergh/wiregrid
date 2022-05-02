#!/usr/bin/env bash

__cppcheck() {
    local filepath="$1"

    output="$(cppcheck --enable=all --language=c --std=c11 --error-exitcode=1 "$filepath" 2>&1)"

    local format_status="$?"
    if [[ "${format_status}" -ne 0 ]]; then
        echo "Failed on file: $filepath"
        echo "$output" >&2
        exit_code=1
        return "${format_status}"
    fi
    return 0
}

cd "$GITHUB_WORKSPACE" || exit 2

exit_code=0

src_files=$(find "$GITHUB_WORKSPACE" -name .git -prune -o -regextype posix-egrep -regex '^.*\.((((c|C)(c|pp|xx|\+\+)?$)|((h|H)h?(pp|xx|\+\+)?$))|(ino|pde)|(proto))$' -print)

# run cppcheck in each source file
for file in $src_files; do
    __cppcheck "${file}"
done

exit "$exit_code"
