class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  url "https://github.com/tseemann/barrnap/archive/refs/tags/0.9.tar.gz"
  sha256 "36c27cd4350531d98b3b2fb7d294a2d35c15b7365771476456d7873ba33cce15"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "3695f106e600e0bd8f21e8ea70d4eea54cdac6f2c27262ed17306b288605031b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7329922f75852f701922912d413f74820b8c557f40d04b7bb28b6ef057ea46e6"
  end

  depends_on "bedtools"
  depends_on "hmmer"

  def install
    # install only bin directory
    # nhmmer is written in "depends_on"
    bin.install Dir["bin/*"]
    prefix.install "examples"
    prefix.install "build"
    prefix.install "db"
  end

  test do
    assert_match "##gff-version", shell_output("#{bin}/barrnap -q #{prefix}/examples/nohits.fna")
    assert_match "Name=16S_rRNA", shell_output("#{bin}/barrnap -q #{prefix}/examples/small.fna")
    assert_match "Name=16S_rRNA", shell_output("#{bin}/barrnap -q --kingdom mito #{prefix}/examples/mitochondria.fna")
    out = testpath/"hits.fa"
    system "#{bin}/barrnap", "--outseq", out, "#{prefix}/examples/small.fna"
    assert_predicate out, :exist?
  end
end
