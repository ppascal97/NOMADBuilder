# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "NOMAD"
version = v"1.0.0"

# Collection of sources required to build NOMAD
sources = [
    "https://www.gerad.ca/nomad/Downloads/unix_linux/NOMAD.zip" =>
    "2134e64d5c8728054a797d0067eb49083d66ca64ed8ad7e75c34700b528aeff3",

]

# Bash recipe for building across all platforms
script = raw"""
export NOMAD_HOME=${WORKSPACE}/srcdir/nomad.3.9.1
export PATH=${NOMAD_HOME}/bin:$PATH
cd $NOMAD_HOME
find . -type f -exec sed -i 's/<math.h>/<cmath>/g' {} +
find . -type f -exec sed -i 's/isnan/std::isnan/g' {} +
find . -type f -exec sed -i 's/isinf/std::isinf/g' {} +
if [ $target = "x86_64-w64-mingw32" ] || [ $target = "i686-w64-mingw32" ]; 
then 
    find . -type f -exec sed -i 's/#ifdef _MSC_VER/#if 1/g' {} + ;
fi
./configure
make
rm -rf doc
rm -rf bin
rm -rf examples
rm -rf lib
rm -rf utils
rm -rf tools
rm -rf ext/sgtelib/bin
rm -rf ext/sgtelib/example
rm -rf ext/sgtelib/matlab_server
rm -rf ext/sgtelib/user_guide
cd builds/release/lib
rm libsgtelib.so
ln -s ../../../ext/sgtelib/lib/libsgtelib.so libsgtelib.so
cp -rf ${NOMAD_HOME} ${prefix}
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = Array{Product,1}()

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
