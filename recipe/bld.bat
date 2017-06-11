:: Patch Boost to fix an incorrect library name.
copy "%RECIPE_DIR%\boost\include\boost\python\detail\config.hpp" "%LIBRARY_INC%\boost\python\detail\config.hpp"
if errorlevel 1 exit 1

set CMAKE_CONFIG=Release
if errorlevel 1 exit 1

mkdir build_%CMAKE_CONFIG%
if errorlevel 1 exit 1

cd build_%CMAKE_CONFIG%
if errorlevel 1 exit 1

cmake .. ^
        -G "NMake Makefiles" ^
        -D CMAKE_BUILD_TYPE="%CMAKE_CONFIG%" ^
        -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
        -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
        -DCMAKE_CXX_FLAGS="%CXXFLAGS% -DH5_BUILT_AS_DYNAMIC_LIB /EHsc /std:c++14" ^
        "%SRC_DIR%"
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake check_python
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
