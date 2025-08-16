class Promod3 < Formula
  # cite Studer_2021: "https://doi.org/10.1371/journal.pcbi.1008667"
  desc "Versatile Homology Modelling Toolbox"
  homepage "https://openstructure.org/promod3"
  url "https://git.scicore.unibas.ch/schwede/ProMod3/-/archive/3.6.0/ProMod3-3.6.0.tar.gz"
  sha256 "9bac495145c0c8ce4f24100a620060d137df865007c880efcc04d4f43f717f6f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "637e26f04353ec69bdb9a2766060d00aa7ef6b036e223c5712f2668d8b5e45d2"
    sha256                               arm64_sonoma:  "e4a3e6baeba7298b39c6512a7c8cf2883b8cfc7a9d31e508ed877cdd03b84eea"
    sha256 cellar: :any,                 ventura:       "800a36c4fb6335d9e0efd1bf9236b45e2e99e01ee55bd565f25238438bcdb864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f3e1b3ed0c6acdb5e1704ee43d8a05414fe177a565f9d1f3887d6ae76a46ed"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "ninja" => :build
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

    cmake_args = std_cmake_args + %W[
      -DPython_ROOT_DIR=#{Formula["python@3.13"].opt_prefix}
      -DOST_ROOT=#{Formula["brewsci/bio/openstructure"].opt_prefix}
      -DOPTIMIZE=ON
      -DDISABLE_DOCUMENTATION=ON
    ]
    cmake_args << "-DENABLE_SSE=ON" if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "check", "--parallel", "1"
    system "cmake", "--install", "build"
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
