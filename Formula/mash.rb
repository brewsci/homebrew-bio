class Mash < Formula
  # cite Ondov_2016: "https://doi.org/10.1186/s13059-016-0997-x"
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/refs/tags/v2.3.tar.gz"
  sha256 "f96cf7305e010012c3debed966ac83ceecac0351dbbfeaa6cd7ad7f068d87fe1"
  head "https://github.com/marbl/Mash.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, mojave:       "ceded4203723c07f1468254f7f1281031bfd8163e948fb1b165659064f7ef5a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d75b04ef71f547af960aab06fe485dd53dd830695508fb0f2f33e1cfd5461b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "capnp"
  depends_on "gsl"

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-capnp=#{formula_opt_prefix("capnp")}",
      "--with-gsl=#{formula_opt_prefix("gsl")}"
    system "make"
    system "make", "test"

    # ideally we should be using "make install" here
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash --version 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    File.exist?("test.msh")
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end
