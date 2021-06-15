class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0634dd14026d1f708341b3ce6dd1d5b9d7c1dcb00f3fad71e64246e293e181e7"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, mojave:       "561513bd343850933d8f034617bb6990100bb8ffbd5f3a6fc7c8145c43401f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0b324a7fa20c5f57d4de10ae5034c2885ad7006c04c24107bef67a33a3c1131f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "armadillo"
  depends_on "nlopt"
  depends_on "openblas"

  def install
    cd "src" do
      on_linux do
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
    assert_predicate testpath/"output.fa", :exist?
  end
end
