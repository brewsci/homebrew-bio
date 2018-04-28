class Barrnap < Formula
  desc "BAsic Rapid Ribosomal RNA Predictor"
  homepage "https://github.com/tseemann/barrnap"
  url "https://github.com/tseemann/barrnap/archive/0.9.tar.gz"
  sha256 "36c27cd4350531d98b3b2fb7d294a2d35c15b7365771476456d7873ba33cce15"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1215c64ca5d2fec2665d0b6167edec78c1a9545a54c2c9bf35c6f531a5d6b5e4" => :sierra_or_later
    sha256 "bcc05e5b81475bb0982cd741f8e94e854d80333abd994d84a53c7084fa5e5c45" => :x86_64_linux
  end

  depends_on "hmmer"
  depends_on "bedtools"

  def install
    prefix.install Dir["*"]
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
