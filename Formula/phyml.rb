class Phyml < Formula
  # cite Guindon_2010: "https://doi.org/10.1093/sysbio/syq010"
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.3.20180621.tar.gz"
  sha256 "a66c1c5758408578c34a17733f92db11a67aa572a06a9b5e3046009ee8bed0d3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8b176e13572c8c3d2dc21ddfc4d52a766f6b45c863b7609c722976100144f994" => :sierra
    sha256 "9cb33e5552ff063ebe5a4717256b78f3b899e783843b3c2fbb3bf100e55824e9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "src/phyml"
    doc.install "doc/phyml-manual.pdf"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phyml --version", 1)
  end
end
