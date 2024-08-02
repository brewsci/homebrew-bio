class Phylonium < Formula
  # cite Kl_tzl_2019: "https://doi.org/10.1093/bioinformatics/btz903"
  desc "Fast and Accurate Estimation of Evolutionary Distances"
  homepage "https://github.com/EvolBioInf/phylonium"
  url "https://github.com/EvolBioInf/phylonium/archive/refs/tags/v1.7.tar.gz"
  sha256 "87fc0828c4c96dc9b84e0bac640e7e1aaba749a9f218e1d4c4fbaa02d80412a0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "2dce8f585ab2d46410e93f321d9f5fffcfda9b337f1d53af3d3d9f4fa25e9855"
    sha256 cellar: :any,                 ventura:      "e6a5b438f8d9a17a15c47b692cf5ea980715a80a7bf1e3ef77e7ec726d9a098e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af27e76f884665486e4a40327b18fe6cda71c524ba932d32cfe99ce405526327"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libdivsufsort"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "autoreconf", "-fvi"
    args = []
    if OS.mac?
      # Work around for OpenMP flag
      args += [
        "--disable-x86simd",
        "--disable-avx512",
        "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
        "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
        "LDFLAGS=-lomp",
        "CXXFLAGS=-std=c++17",
      ]
    end
    # fix a mismatch argument types error
    inreplace "src/process.cxx", "this_length = std::max(inter.l, 0l)",
                                 "this_length = std::max(static_cast<long>(inter.l), 0l)"

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylonium --version 2>&1")

    resource("simf") do
      url "https://raw.githubusercontent.com/EvolBioInf/phylonium/3baee10acbb82fc33f2b052d6adf10d33e8b64cf/test/simf.cxx"
      sha256 "31642a3c0f9fbfd7fe6de3a4819599b87b426fd96a1bebb37c9d4ee9d48dfb1b"
    end

    resource("simf").stage do
      system ENV.cxx.to_s, "-std=c++17", "-Wall", "-Wextra", "simf.cxx", "-o", "simf"
      system "./simf", "-s", "1729", "-l", "100000", "-p", "simple"
      system "#{bin}/phylonium simple0.fasta simple1.fasta > /dev/null"
      rm "simple0.fasta"
      rm "simple1.fasta"
    end
  end
end
