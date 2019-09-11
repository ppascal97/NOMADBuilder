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
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    FileProduct(prefix, "Parameters", Symbol("")),
    FileProduct(prefix, "Slave", Symbol("")),
    FileProduct(prefix, "nomad", Symbol("")),
    FileProduct(prefix, "Pareto_Point", Symbol("")),
    FileProduct(prefix, "TrendMatrix_Line_Search", Symbol("")),
    LibraryProduct(prefix, "libnomad", Symbol("")),
    FileProduct(prefix, "RNG", Symbol("")),
    FileProduct(prefix, "Surrogate_PRS_CAT", Symbol("")),
    LibraryProduct(prefix, "libsgtelib", Symbol("")),
    FileProduct(prefix, "Directions", Symbol("")),
    FileProduct(prefix, "Quad_Model_Search", Symbol("")),
    FileProduct(prefix, "Signature", Symbol("")),
    FileProduct(prefix, "Cache_Point", Symbol("")),
    FileProduct(prefix, "Clock", Symbol("")),
    FileProduct(prefix, "NelderMead_Search", Symbol("")),
    FileProduct(prefix, "Sgtelib_Model_Evaluator", Symbol("")),
    FileProduct(prefix, "Phase_One_Search", Symbol("")),
    FileProduct(prefix, "Parameter_Entry", Symbol("")),
    FileProduct(prefix, "SMesh", Symbol("")),
    FileProduct(prefix, "utils", Symbol("")),
    FileProduct(prefix, "Matrix", Symbol("")),
    FileProduct(prefix, "Surrogate", Symbol("")),
    FileProduct(prefix, "Metrics", Symbol("")),
    FileProduct(prefix, "Surrogate_LOWESS", Symbol("")),
    FileProduct(prefix, "Cache_Search", Symbol("")),
    FileProduct(prefix, "sgtelib", Symbol("")),
    FileProduct(prefix, "Algo_Parameters", Symbol("")),
    FileProduct(prefix, "Surrogate_CN", Symbol("")),
    FileProduct(prefix, "TrainingSet", Symbol("")),
    FileProduct(prefix, "Quad_Model_Evaluator", Symbol("")),
    FileProduct(prefix, "Kernel", Symbol("")),
    FileProduct(prefix, "L_Curve", Symbol("")),
    FileProduct(prefix, "Surrogate_RBF", Symbol("")),
    FileProduct(prefix, "Eval_Point", Symbol("")),
    FileProduct(prefix, "Pareto_Front", Symbol("")),
    FileProduct(prefix, "Priority_Eval_Point", Symbol("")),
    FileProduct(prefix, "Speculative_Search", Symbol("")),
    FileProduct(prefix, "Surrogate_Parameters", Symbol("")),
    FileProduct(prefix, "sgtelib_help", Symbol("")),
    FileProduct(prefix, "Display", Symbol("")),
    FileProduct(prefix, "GMesh", Symbol("")),
    FileProduct(prefix, "Phase_One_Evaluator", Symbol("")),
    FileProduct(prefix, "Variable_Group", Symbol("")),
    FileProduct(prefix, "Surrogate_PRS_EDGE", Symbol("")),
    FileProduct(prefix, "Evaluator_Control", Symbol("")),
    FileProduct(prefix, "Surrogate_Ensemble", Symbol("")),
    FileProduct(prefix, "Mads", Symbol("")),
    FileProduct(prefix, "NelderMead_Simplex_Eval_Point", Symbol("")),
    FileProduct(prefix, "Direction", Symbol("")),
    FileProduct(prefix, "Point", Symbol("")),
    FileProduct(prefix, "LH_Search", Symbol("")),
    FileProduct(prefix, "Extended_Poll", Symbol("")),
    FileProduct(prefix, "Surrogate_KS", Symbol("")),
    FileProduct(prefix, "Surrogate_Kriging", Symbol("")),
    FileProduct(prefix, "Stats", Symbol("")),
    FileProduct(prefix, "Model_Sorted_Point", Symbol("")),
    FileProduct(prefix, "Cache_File_Point", Symbol("")),
    FileProduct(prefix, "Multi_Obj_Evaluator", Symbol("")),
    FileProduct(prefix, "Sgtelib_Model_Manager", Symbol("")),
    FileProduct(prefix, "Barrier", Symbol("")),
    FileProduct(prefix, "Quad_Model", Symbol("")),
    FileProduct(prefix, "VNS_Search", Symbol("")),
    FileProduct(prefix, "Tests", Symbol("")),
    FileProduct(prefix, "XMesh", Symbol("")),
    FileProduct(prefix, "Surrogate_Utils", Symbol("")),
    FileProduct(prefix, "Parameter_Entries", Symbol("")),
    FileProduct(prefix, "Cache", Symbol("")),
    FileProduct(prefix, "Sgtelib_Model_Search", Symbol("")),
    FileProduct(prefix, "Model_Stats", Symbol("")),
    FileProduct(prefix, "Surrogate_Factory", Symbol("")),
    FileProduct(prefix, "Double", Symbol("")),
    FileProduct(prefix, "Surrogate_PRS", Symbol("")),
    FileProduct(prefix, "OrthogonalMesh", Symbol("")),
    ExecutableProduct(prefix, "sgtelib", Symbol("")),
    FileProduct(prefix, "Evaluator", Symbol("")),
    FileProduct(prefix, "Random_Pickup", Symbol("")),
    ExecutableProduct(prefix, "nomad", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
