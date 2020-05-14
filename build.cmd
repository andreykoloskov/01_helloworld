if exist build (
    echo "DELETE build directory"
    rd /s /q build
)

echo "CREATE build directory"
md build

cd build

set TRAVIS_BUILD_NUMBER=1

echo "call cmake"
cmake ^
	-DBOOST_ROOT=C:\Users\Andrey\Documents\post_msu_prac\boost_1_69_0_win ^
	-DBOOST_INCLUDEDIR=C:\Users\Andrey\Documents\post_msu_prac\boost_1_69_0_win\boost ^
	-DBOOST_LIBRARYDIR=C:\Users\Andrey\Documents\post_msu_prac\boost_1_69_0_win\stage\lib ^
    -A x64 ..

cmake --build . --config Release -- -m:12
cmake --build . --config Debug -- -m:12

cmake -E env CTEST_OUTPUT_ON_FAILURE=1
ctest . -C Release
ctest . -C Debug

cpack -C Release
