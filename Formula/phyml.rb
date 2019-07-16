class Phyml < Formula
  # cite Guindon_2010: "https://doi.org/10.1093/sysbio/syq010"
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.3.20190321.tar.gz"
  sha256 "5274546cda7445c947fd26838487cd4246e2becf18d333882b7a2a24dff853ee"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a578ab66e19ae5062fb6e61008220c9576d723c974f2da2f76b9b0bd4fe50dbd" => :sierra
    sha256 "601324d1a3ab1a474f468dd22e60be48a65fb716b591d6ba5a7c904fd839c902" => :x86_64_linux
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
