#!/usr/bin/env bash

# CMake build directory
BUILD_DIR=build/

__clang_tidy() {
    local filepath="$1"

    output="$(clang-tidy --export-fixes=clang-tidy.txt --checks="*" -p "$BUILD_DIR" "$filepath" 2>&1)"

    echo "$output"

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

# TODO exclude build/ dir C files
src_files=$(find "$GITHUB_WORKSPACE" -name .git -prune -o -regextype posix-egrep -regex '^.*\.((((c|C)(c|pp|xx|\+\+)?$)|((h|H)h?(pp|xx|\+\+)?$))|(ino|pde)|(proto))$' -print)

echo $src_files

# run clang-tidy in each source file
for file in $src_files; do
    __clang_tidy "${file}"
done

exit "$exit_code"
