class Phyml < Formula
  # cite Guindon_2010: "https://doi.org/10.1093/sysbio/syq010"
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.3.20180214.tar.gz"
  sha256 "ec059e3662874be3fdf1a9dc6d71fe4d568d987f66da9495f154f8f49c6d153e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "767f89eff7087e57b5b485cae3326911b10070a4eedced1051325830c1a00b79" => :sierra_or_later
    sha256 "b600dfae5207edd400f05b8ad45129301fdb50f0522f55687f64a72cad17c6d2" => :x86_64_linux
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
