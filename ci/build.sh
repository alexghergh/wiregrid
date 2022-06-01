build_wiregrid() {

    if [ "${OS_NAME}" = "macos-latest" ] && [ "${CC}" = "gcc" ]; then
        # since the system's gcc is just a symlink to clang on macos,
        # we have to specifically mention the path to it
        #
        # keep this in sync with the gcc version used
        CC="/usr/local/bin/gcc-11"
    fi

    echo "Running cmake.."
    cmake -B build/ || exit

    echo "Running make.."
    make -C build/ || exit
}

build_wiregrid
