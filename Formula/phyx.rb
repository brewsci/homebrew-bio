class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "2c4a80c73b8bbf2117c4a4686655c19f9e0a1f81921cd1ad201b1933e1c6ad14"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "0eff1ebe804ec069e062e85c65f4acfd43b8467caf4ecdd7597ab70abe9ce8a9"
    sha256 cellar: :any, arm64_sequoia: "784c10e6a4ca3a788ae8d3fb1f005ecf186dc24f04d5e954a2511da297c33ead"
    sha256 cellar: :any, arm64_sonoma:  "c632b168fe0933a3e81e767db5c3c83ca9530c86c2161fee651c22c311fa6725"
    sha256 cellar: :any, x86_64_linux:  "19067749fab4dfb14836c63e331cadfb7cbe60b308f4a7d5489944cd377bc58f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "armadillo"
  depends_on "nlopt"
  depends_on "openblas"

  def install
    cd "src" do
      if OS.linux?
        # Disable opportunistic linking to libmvec,
        # which causes runtime errors on glibc > 2.19 and < 2.22
        inreplace "Makefile.in", "-ftree-vectorize", "-fno-tree-vectorize"
      end
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
    pkgshare.install Dir["example_files/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pxseqgen --help")
    system "#{bin}/pxseqgen", "-t", "#{pkgshare}/pxseqgen_example/seqgen_test.tre", "-o", "output.fa"
    assert_path_exists testpath/"output.fa"
  end
end
