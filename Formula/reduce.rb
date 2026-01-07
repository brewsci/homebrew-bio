class Reduce < Formula
  # cite Word_1999: "https://doi.org/10.1006/jmbi.1998.2401"
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.15.tar.gz"
  sha256 "f2f993e3f86ded38135d6433e0a7c2ed10fbe5da37f232c04d7316702582ed06"
  license "BSD-4-Clause-UC"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256               arm64_tahoe:   "3725148463200bdd63ccae3e257e3c18bf0e8f82389a27ed715cb58b15fe235d"
    sha256               arm64_sequoia: "bd8706882467128f29000707a1abf40951a4d178a356e4a5de612aff1004b67f"
    sha256 cellar: :any, arm64_sonoma:  "42fb98231f0efa94ebb26ff5ca763b99195b40412f81347465325e98da3c53ca"
    sha256               x86_64_linux:  "422b59906fd7d471efa3295c2a129b2062ab69918df9ecdf3a9f4d7e803f70e3"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "boost-python3"
  depends_on "python3"

  def install
    ENV.append "CXXFLAGS", "-O3"
    ENV.append "LDFLAGS", "-undefined dynamic_lookup" if OS.mac?

    inreplace "reduce_src/CMakeLists.txt",
              "target_link_libraries(mmtbx_reduceOrig_ext PRIVATE reducelib ${Boost_LIBRARIES} ${PYTHON_LIBRARIES})",
              "target_link_libraries(mmtbx_reduceOrig_ext PRIVATE reducelib ${Boost_LIBRARIES})"

    # Refer to https://github.com/rlabduke/reduce/issues/60 for `-DHET_DICTIONARY` and `-DHET_DICTOLD` flags
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args,
      "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}",
      "-DHET_DICTIONARY=#{pkgshare/"reduce_wwPDB_het_dict.txt"}",
      "-DHET_DICTOLD=#{pkgshare/"reduce_het_dict.txt"}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "reduce_wwPDB_het_dict.txt", "update_het_dict.py"
    prefix.install_metafiles

    # Install a shared library file and a Python module
    py_ver = Language::Python.major_minor_version "python3"
    site_packages = lib/"python#{py_ver}/site-packages"
    mkdir_p site_packages
    cp "build/reduce_src/mmtbx_reduceOrig_ext.so", site_packages
    cp "build/reduce_src/reduce.py", site_packages
    chmod 0644, site_packages/"mmtbx_reduceOrig_ext.so"
    chmod 0644, site_packages/"reduce.py"
  end

  def post_install
    # Remove mislocated reduce_wwPDB_het_dict.txt
    # TODO: Remove this block after upstream PR (https://github.com/rlabduke/reduce/pull/66) is merged
    rm "#{prefix}/reduce_wwPDB_het_dict.txt"
  end

  test do
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end

    output = shell_output("#{bin}/reduce -Version 2>&1", 2)
    assert_match "reduce.4.15.250408", output
    resource("homebrew-testdata").stage testpath
    system("#{bin}/reduce -NOFLIP -Quiet 3QUG.pdb > 3QUG_H.pdb")
    assert_match "add=1978, rem=0, adj=70", File.read("3QUG_H.pdb")

    # Check if the Python module can be imported
    system "python3", "-c", "import reduce"
  end
end
