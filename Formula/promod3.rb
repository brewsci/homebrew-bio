class Promod3 < Formula
  # cite Studer_2021: "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.5.0/ProMod3-3.5.0.tar.gz"
  sha256 "a358d799581e8dee783fda1e9e16cad48b1b3c46ded6321600bd7697fad74539"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "42de23f278d08076caf9fe3165254e1f1098e855eea0510fac47f9d526702d5a"
    sha256                               arm64_sonoma:  "4c6a68928bb78e915d437a06779f72e24f31887433ec47521a8bcc7ab09a3b7c"
    sha256 cellar: :any,                 ventura:       "470ef5e9d9136b768a64b41211e48773a35353d93ae9033d029bc3e43186a478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c3ffc93c622d94d13ef8023b8f1d2cfec9a0867bc139ab4fad5ec08cfc4d4b"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/openmm@7"
  depends_on "brewsci/bio/openstructure"
  depends_on "python@3.13"

  def install
    if OS.mac?
      ENV.prepend "LDFLAGS", "-undefined dynamic_lookup -Wl,-export_dynamic"
    elsif OS.linux?
      ENV.prepend "LDFLAGS", "-Wl,--allow-shlib-undefined,--export-dynamic -lstdc++"
    end

    # Match homebrew shared library directory name
    inreplace "cmake_support/PROMOD3.cmake", "lib64", "lib"

    # Disable linking directly to CPython shared libraries
    inreplace "cmake_support/PROMOD3.cmake", "set(CMAKE_CXX_STANDARD 17)", "set(CMAKE_CXX_STANDARD 11)"
    inreplace "cmake_support/PROMOD3.cmake", /\s*\$\{Python_LIBRARIES\}\s*/, " "
    inreplace "CMakeLists.txt", "find_package(Python 3.6", "find_package(Python 3"

    mkdir "build" do
      cmake_args = std_cmake_args + %W[
        -DCMAKE_CXX_STANDARD=11
        -DPython_ROOT_DIR=#{Formula["python@3.13"].opt_prefix}
        -DOST_ROOT=#{Formula["brewsci/bio/openstructure"].opt_prefix}
        -DOPTIMIZE=ON
        -DDISABLE_DOCUMENTATION=ON
      ]
      cmake_args << "-DENABLE_SSE=ON" if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "pm <action>", shell_output("#{bin}/pm 2>&1", 1)
    ENV.prepend_path "PYTHONPATH", lib/"python3.13/site-packages"

    (testpath/"gen_pdb.py").write <<~EOS
      from ost import io
      from promod3 import loop

      sequence = "HELLYEAH"
      bb_list = loop.BackboneList(sequence)
      io.SavePDB(bb_list.ToEntity(), "test.pdb")
    EOS

    system Formula["python@3.13"].opt_bin/"python3", "gen_pdb.py"
    assert_match(/^ATOM\s+3\s+C\s+HIS\s+A\s+/, (testpath/"test.pdb").read)
  end
end
