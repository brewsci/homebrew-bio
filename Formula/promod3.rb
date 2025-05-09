class Promod3 < Formula
  # cite "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.4.2/ProMod3-3.4.2.tar.gz"
  sha256 "8103bcb344489eb0fa0567ad8c9a8a9b42d3dbbb8d46c82587e6a58eab45eefd"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/openmm@7"
  depends_on "openstructure"
  depends_on "python@3.13"

  def install
    mkdir "build" do
      system "cmake", "..",
        "-DCMAKE_CXX_COMPILER=#{ENV["CXX"]}",
        "-DCMAKE_CXX_STANDARD=11",
        "-DOST_ROOT=#{Formula["openstructure"].opt_prefix}",
        "-DOPTIMIZE=ON",
        "-DENABLE_SSE=ON",
        "-DDISABLE_DOCUMENTATION=ON",
        *std_cmake_args
      system "make"
      system "make", "check" # Test suite for built binaries
      system "make", "install"
    end
  end

  test do
    assert_match "pm <action>", shell_output("#{bin}/pm 2>&1", 1)
  end
end
