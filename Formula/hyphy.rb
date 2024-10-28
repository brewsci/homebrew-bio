class Hyphy < Formula
  desc "Hypothesis testing with phylogenies"
  homepage "http://www.hyphy.org/"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.63.tar.gz"
  sha256 "8c84340665b126742b85ed8d54354455ffc97ebd3cc689658120d7f5791adf13"
  head "https://github.com/veg/hyphy.git"
  # tag "bioinformatics"

  option "with-opencl", "Build a version with OpenCL GPU/CPU acceleration"
  option "without-multi-threaded", "Don't build a multi-threaded version"
  option "without-single-threaded", "Don't build a single-threaded version"
  deprecated_option "with-mpi" => "with-open-mpi"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "open-mpi" => :optional

  patch :DATA # single-threaded builds

  def install
    system "cmake", "-DINSTALL_PREFIX=#{prefix}", ".", *std_cmake_args
    system "make", "SP" if build.with? "single-threaded"
    system "make", "MP2" if build.with? "multi-threaded"
    system "make", "MPI" if build.with? "open-mpi"
    system "make", "OCL" if build.with? "opencl"
    system "make", "GTEST"

    system "make", "install"
    libexec.install "HYPHYGTEST"
    doc.install("help")
  end

  def caveats
    <<~EOS
      The help has been installed to #{doc}/hyphy.
    EOS
  end

  test do
    system libexec/"HYPHYGTEST"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 76228a8..ee4bb80 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -299,6 +299,23 @@ add_custom_target(MP2 DEPENDS HYPHYMP)
 
 
 #-------------------------------------------------------------------------------
+# hyphy sp target
+#-------------------------------------------------------------------------------
+add_executable(
+    HYPHYSP
+    EXCLUDE_FROM_ALL
+    ${SRC_COMMON} ${SRC_UNIXMAIN}
+)
+target_link_libraries(HYPHYSP ${DEFAULT_LIBRARIES})
+install(
+    TARGETS HYPHYSP
+    RUNTIME DESTINATION bin
+    OPTIONAL
+)
+add_custom_target(SP DEPENDS HYPHYSP)
+
+
+#-------------------------------------------------------------------------------
 # hyphy OpenCL target
 #-------------------------------------------------------------------------------
 find_package(OpenCL)
@@ -546,7 +563,7 @@ endif((${QT4_FOUND}))
 #-------------------------------------------------------------------------------
 if(UNIX)
     set_property(
-        TARGET HYPHYMP hyphy_mp HYPHYGTEST HYPHYDEBUG
+        TARGET HYPHYMP hyphy_mp HYPHYGTEST HYPHYDEBUG HYPHYSP
         APPEND PROPERTY COMPILE_DEFINITIONS __UNIX__
     )
 endif(UNIX)
@@ -557,7 +574,7 @@ set_property(
 )
 
 set_property(
-    TARGET hyphy_mp HYPHYMP HYPHYGTEST HYPHYDEBUG
+    TARGET hyphy_mp HYPHYMP HYPHYGTEST HYPHYDEBUG HYPHYSP
     APPEND PROPERTY COMPILE_DEFINITIONS _HYPHY_LIBDIRECTORY_="${CMAKE_INSTALL_PREFIX}/lib/hyphy"
 )
 
@@ -567,6 +584,13 @@ set_property(
 )
 
 set_target_properties(
+    HYPHYSP
+    PROPERTIES
+    COMPILE_FLAGS "${DEFAULT_COMPILE_FLAGS}"
+    LINK_FLAGS "${DEFAULT_LINK_FLAGS}"
+)
+
+set_target_properties(
     hyphy_mp HYPHYMP
     PROPERTIES
     COMPILE_FLAGS "${DEFAULT_COMPILE_FLAGS} ${OpenMP_CXX_FLAGS}"
