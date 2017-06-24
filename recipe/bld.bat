mkdir build
if errorlevel 1 exit 1

cd build
if errorlevel 1 exit 1

cmake .. ^
        -G "NMake Makefiles" ^
        -DCMAKE_BUILD_TYPE="Release" ^
        -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
        -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
        -DBUILD_SHARED_LIBS=1 ^
        -DCMAKE_CXX_FLAGS="%CXXFLAGS% -DH5_BUILT_AS_DYNAMIC_LIB /EHsc" ^
        -DZLIB_INCLUDE_DIR="%LIBRARY_INC%" ^
        -DZLIB_LIBRARY="%LIBRARY_LIB%\zlib.lib" ^
        "%SRC_DIR%"
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake check_python
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
