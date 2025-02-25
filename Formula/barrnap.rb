class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  url "https://github.com/tseemann/barrnap/archive/refs/tags/0.9.tar.gz"
  sha256 "36c27cd4350531d98b3b2fb7d294a2d35c15b7365771476456d7873ba33cce15"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "98d207d07bcb6abefcb86abe70b01695a9294690c5595bd2650d4ddfd4243273"
    sha256 cellar: :any_skip_relocation, ventura:      "98d207d07bcb6abefcb86abe70b01695a9294690c5595bd2650d4ddfd4243273"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa54aacd026c294c7b4cdec6cf2c0204cd056508656065b794e80c663644abd3"
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
    assert_path_exists out
  end
end
