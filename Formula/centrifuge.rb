class Centrifuge < Formula
  # cite Kim_2016: "https://doi.org/10.1101/gr.210641.116"
  desc "Rapid sensitive classification of metagenomic sequences"
  homepage "http://www.ccb.jhu.edu/software/centrifuge"
  url "https://github.com/infphilo/centrifuge/archive/v1.0.3.tar.gz"
  sha256 "71340f5c0c20dd4f7c4d98ea87f9edcbb1443fff8434e816a5465cbebaca9343"
  license "GPL-3.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd12f24f14e0fd03e3b534bce48f4c1fd54652473b95daf306bdace8aa101af9"
  end

  depends_on "gcc" if OS.mac? # needs openmp

  # classifier.h:431:45: error: the value of 'rank' is not usable in a constant expression
  depends_on :linux

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "centrifuge", Dir["centrifuge-*"]
    pkgshare.install "example", "indices", "evaluation"
    doc.install "doc", "MANUAL", "TUTORIAL"
  end

  def caveats
    <<~EOS
      The Makefile for building indices was installed to:
        #{pkgshare}/indices
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/centrifuge --version 2>&1")
  end
end
