class Promod3 < Formula
  # cite Studer_2021: "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.4.2/ProMod3-3.4.2.tar.gz"
  sha256 "8103bcb344489eb0fa0567ad8c9a8a9b42d3dbbb8d46c82587e6a58eab45eefd"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "15dbf51dc0b5cd4a7573a1dc5b82d0098c6bfeeedaffd7b81d305a0242222a88"
    sha256                               arm64_sonoma:  "1c9800f0b2b07554b0489390e41f55b3683f00a26a93cd27711b7e2e0dec416b"
    sha256 cellar: :any,                 ventura:       "421bbcbd0f829747aab8592610ce34ccca5d4eefbf0b06d8e6d08981109df970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdea303173a44c865c99c25bbabc8fcecfec7449bd5f1b934d2f1cea3b241be9"
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
    inreplace "cmake_support/PROMOD3.cmake",
      /^\s*set\(CMAKE_REQUIRED_FLAGS "\$\{CMAKE_REQUIRED_FLAGS\} \$\{Python_LIBRARIES\}"\)\n?/, ""
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
