class Phyml < Formula
  # cite Guindon_2010: "https://doi.org/10.1093/sysbio/syq010"
  desc "Fast maximum likelihood-based phylogenetic inference"
  homepage "http://www.atgc-montpellier.fr/phyml/"
  url "https://github.com/stephaneguindon/phyml/archive/refs/tags/v3.3.20250515.tar.gz"
  # There is a mismatch between archive and version
  version "3.3.20250429"
  sha256 "c8d09f52f080a95dde8d7d797da5874796a148158cd18f956110cdba13cd3368"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd2486bab6bfa0c3d5b4f53d307929727c789b82bc5b13c2dd7d41659da93cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bf1cbd05010af7a238b01f8d21a8892e3d7bb3cfae3954c6923f78d782f3ed5"
    sha256 cellar: :any_skip_relocation, ventura:       "9aae7991b2a29d53fa5f8f545ca722c340ac6d48d1488b0bd025eccfc166bb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a59a2b3497bc03def401b2e6e898bc38a07fb3c693da68e8057123ffee32f994"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-phyml"
    system "make"
    bin.install "src/phyml"
    doc.install "doc/phyml-manual.pdf"
    pkgshare.install Dir["examples/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phyml --version", 1)
  end
end
