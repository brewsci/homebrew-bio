class Reduce < Formula
  # cite Word_1999: "https://doi.org/10.1006/jmbi.1998.2401"
  desc "Tool for adding and correcting hydrogens in PDB files"
  homepage "https://github.com/rlabduke/reduce"
  url "https://github.com/rlabduke/reduce/archive/refs/tags/v4.15.tar.gz"
  sha256 "f2f993e3f86ded38135d6433e0a7c2ed10fbe5da37f232c04d7316702582ed06"
  license "BSD-4-Clause-UC"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "e9fb021699f5d1f200721ac41505296d804730ba89463cbec49a902aef8cd49e"
    sha256 cellar: :any, arm64_sonoma:  "118b939702512fb76092256336be88ba24aab837c343028816c23d89c605abcf"
    sha256 cellar: :any, ventura:       "147984754506da87f86db5613b09e67dae197de0acf8246b797c69b7292e880d"
    sha256               x86_64_linux:  "b02c9696e18765ccce357ca1881dfe08e90c150cd3c53b2bd92f0c4e4296fe7d"
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

    mkdir_p pkgshare

    # Refer to https://github.com/rlabduke/reduce/issues/60 for `-DHET_DICTIONARY` and `-DHET_DICTOLD` flags
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args,
      "-DCMAKE_CXX_FLAGS=#{ENV.cxxflags}",
      "-DHET_DICTIONARY=#{pkgshare/"reduce_wwPDB_het_dict.txt"}",
      "-DHET_DICTOLD=#{pkgshare/"reduce_het_dict.txt"}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "update_het_dict.py"
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
