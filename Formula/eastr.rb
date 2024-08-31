class Eastr < Formula
  # cite Shinder_2023: "https://doi.org/10.1038/s41467-023-43017-4"
  include Language::Python::Virtualenv
  desc "Emending Alignment of Spliced Transcript Reads"
  homepage "https://github.com/gpertea/gffread/"
  url "https://github.com/ishinder/EASTR.git",
    tag:      "v1.0-paper",
    revision: "3ce55dc40a6b3de816f61e52508993816e90bdbb"
  version "1.0"
  license "MIT"
  head "https://github.com/ishinder/EASTR.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "brewsci/bio/gffread" => :test
  depends_on "sratoolkit" => :test
  depends_on "bowtie2"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "samtools"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/9e/7f/eaca4de03f0ee06c9d578d2730fd55858a57cee3620c62d3bc17b5da5447/biopython-1.84.tar.gz"
    sha256 "60fbe6f996e8a6866a42698c17e552127d99a9aab3259d6249fbaabd0e0cc7b4"
  end

  resource "mappy" do
    url "https://files.pythonhosted.org/packages/90/48/9818341371f20a2644267a1769aaecb7642f74839192afad278a38e0fe14/mappy-2.28.tar.gz"
    sha256 "0ebf7a5d62bd668f5456028215e26176e180ca68161ac18d4f7b48045484cebb"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/88/d9/ecf715f34c73ccb1d8ceb82fc01cd1028a65a5f6dbc57bfa6ea155119058/pandas-2.2.2.tar.gz"
    sha256 "9e79019aba43cb4fda9e4d983f8e88ca0373adbb697ae9c6c43093218de28b54"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/a6/bc/e0a79d74137643940f5406121039d1272f29f55c5330e7b43484b2259da5/pysam-0.22.1.tar.gz"
    sha256 "18a0b97be95bd71e584de698441c46651cdff378db1c9a4fb3f541e560253b22"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  patch :DATA

  def install
    cd "utils" do
      # Use Homebrew's htslib
      inreplace "CMakeLists.txt" do |s|
        s.gsub! "${CMAKE_SOURCE_DIR}/include/htslib/libhts.a", "hts"
        s.gsub! "add_dependencies(vacuum htslib)", "# add_dependencies(vacuum htslib)"
        s.gsub! "add_dependencies(junction_extractor htslib)", "# add_dependencies(junction_extractor htslib)"
      end
      inreplace ["src/GSam.h", "src/tmerge.h"], "htslib/htslib", "htslib"
      inreplace "src/vacuum.cpp", "strverscmp", "strcmp"
      system "cmake", ".", *std_cmake_args
      system "make"
      bin.install "vacuum", "junction_extractor"
    end
    # pkg_resources is not available in Python 3.12
    inreplace "EASTR/utils.py" do |s|
      s.gsub! "import pkg_resources", "import importlib.resources as resources"
      s.gsub! "pkg_resources.resource_filename", "resources.files"
    end
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/eastr --help")
  end
end
__END__
diff --git a/utils/CMakeLists.txt b/utils/CMakeLists.txt
index 05028a3..1a1d8a1 100644
--- a/utils/CMakeLists.txt
+++ b/utils/CMakeLists.txt
@@ -6,16 +6,16 @@ set(CMAKE_CXX_STANDARD 11)
 set(CMAKE_CXX_FLAGS "${CMAKE_sCXX_FLAGS} -fpermissive -DNOCURL=1")
 include_directories("${CMAKE_SOURCE_DIR}/include/")
 link_directories("${CMAKE_SOURCE_DIR}/include/htslib")
-include(ExternalProject)
-ExternalProject_Add(htslib
-        SOURCE_DIR ${CMAKE_SOURCE_DIR}/include/htslib
-        # if this is not specified, need to include the packages manually
-        GIT_REPOSITORY https://github.com/samtools/htslib.git
-        BUILD_IN_SOURCE 1
-        CONFIGURE_COMMAND autoheader COMMAND autoconf COMMAND ./configure --without-libdeflate --disable-libcurl --disable-lzma
-        BUILD_COMMAND ${MAKE}
-        INSTALL_COMMAND ""
-        )
+# include(ExternalProject)
+# ExternalProject_Add(htslib
+#         SOURCE_DIR ${CMAKE_SOURCE_DIR}/include/htslib
+#         # if this is not specified, need to include the packages manually
+#         GIT_REPOSITORY https://github.com/samtools/htslib.git
+#         BUILD_IN_SOURCE 1
+#         CONFIGURE_COMMAND autoheader COMMAND autoconf COMMAND ./configure --without-libdeflate --disable-libcurl --disable-lzma
+#         BUILD_COMMAND ${MAKE}
+#         INSTALL_COMMAND ""
+#         )
