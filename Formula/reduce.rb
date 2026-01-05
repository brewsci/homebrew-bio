class Reduce < Formula
  # cite Word_1999: "https://doi.org/10.1006/jmbi.1998.2401"
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.15.tar.gz"
  sha256 "f2f993e3f86ded38135d6433e0a7c2ed10fbe5da37f232c04d7316702582ed06"
  license "BSD-4-Clause-UC"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any, arm64_sequoia: "b1382e71fefa40d51b73e4da3354964a49e65e19e76230ac0f7806bd02b428f8"
    sha256 cellar: :any, arm64_sonoma:  "dd321f2f4642db01fc51a6f6d28eafab187ad711ec382e9624d5011258acdb38"
    sha256 cellar: :any, ventura:       "6ae93270e924daa395ac87d28316764751a48319b5996adec27d732a6ceb7cdb"
    sha256               x86_64_linux:  "b9b305a675c20063909889d26d5850c8a5f65153838221d8846ba6437857ca5f"
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
    rm prefix/"reduce_wwPDB_het_dict.txt"
  end

  test do
    resource "homebrew-testdata" do
      url "https://files.rcsb.org/download/3QUG.pdb"
      sha256 "7b71128bedcd7ebdea42713942a30af590b3cf514726485f9aa27430c3999657"
    end

    output = shell_output(bin/"reduce -Version 2>&1", 2)
    assert_match "reduce.4.15.250408", output
    resource("homebrew-testdata").stage testpath
    system("#{bin}/reduce -NOFLIP -Quiet 3qug.pdb > 3qug_h.pdb")
    assert_match "add=1978, rem=0, adj=70", File.read("3qug_h.pdb")

    # Check if the Python module can be imported
    system "python3", "-c", "import reduce"
  end
end
