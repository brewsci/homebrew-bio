class Promod3 < Formula
  # cite "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.4.2/ProMod3-3.4.2.tar.gz"
  sha256 "8103bcb344489eb0fa0567ad8c9a8a9b42d3dbbb8d46c82587e6a58eab45eefd"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "gcc@12" => :build
  depends_on "openstructure"

  def install
    if OS.linux?
        ENV["CXX"] = Formula["gcc@12"].opt_bin/"g++-12"
    end

    mkdir "build" do
      system "cmake", "..",
        "-DCMAKE_CXX_COMPILER=#{ENV["CXX"]}",
        "-DCMAKE_CXX_STANDARD=17",
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
    assert_match "Usage", shell_output("#{bin}/pm 2>&1", 1)
  end
end
