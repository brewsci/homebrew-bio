class Phyml < Formula
  # cite Guindon_2010: "https://doi.org/10.1093/sysbio/syq010"
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/v3.3.20250515.tar.gz"
  version "3.3.20250429"
  sha256 "c8d09f52f080a95dde8d7d797da5874796a148158cd18f956110cdba13cd3368"
  license "GPL-3.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "adac7f68bc36a7bd0b4954749d2293af62ea6d9fe91febed13d84f514f089ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7253c8ac68f4f24790adc53d49c9030fd0113fe8f33c482375c47874386ce43e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--enable-phyml"
    system "make"
    bin.install "src/phyml"
    doc.install "doc/phyml-manual.pdf"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phyml --version", 1)
  end
end
