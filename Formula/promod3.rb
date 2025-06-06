class Promod3 < Formula
  # cite Studer_2021: "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.5.0/ProMod3-3.5.0.tar.gz"
  sha256 "a358d799581e8dee783fda1e9e16cad48b1b3c46ded6321600bd7697fad74539"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "f59661ec3f3bfefbc7c9377e698bbf6f58e55f812e9f10113f7ef05bb94bbde5"
    sha256                               arm64_sonoma:  "3043efb9e70a20aed11a488fcb30768d5fad0ddf52dc73c657480a3e006a06f3"
    sha256 cellar: :any,                 ventura:       "e88dd2cbcdebac4cc708c017d4d1885eb1ca35871bb826e39a1f19170b0a233f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa4b27c6cd52f915ff5c68d4f217ed5018b41c30ae45f961edeb6fbda1d95c7"
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
