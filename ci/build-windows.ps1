function exitIfFailed() {
  if ($LastExitCode -ne 0) {
    exit $LastExitCode
  }
}

if ($Env:CONFIG -eq 'MSVC') {
    # Microsoft Visual C Compiler
    $Env:CC = 'cl'
    cmake -B build\ ; exitIfFailed

    cd build\
    nmake /F Makefile ; exitIfFailed

} elseif ($Env:CONFIG -eq 'MINGW') {

    # add msys2 bin dir to the path
    # !important: this needs to be first in the path
    # keep in sync with the windows build workflow
    $Env:PATH = "D:\msys64\usr\bin;$Env:PATH"

    # MinGW gcc for Windows
    $Env:CC = 'gcc'

    # see https://www.msys2.org/docs/cmake/ for generators
    cmake -G "MinGW Makefiles" -B build\ ; exitIfFailed

    make -C build\ ; exitIfFailed
}
