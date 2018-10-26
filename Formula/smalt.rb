class Smalt < Formula
  desc "Aligns DNA sequencing reads with a reference genome"
  homepage "https://www.sanger.ac.uk/science/tools/smalt-0"
  url "https://downloads.sourceforge.net/project/smalt/smalt-0.7.6.tar.gz"
  sha256 "89ccdfe471edba3577b43de9ebfdaedb5cd6e26b02bf4000c554253433796b31"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "cd6b0f671a4a141122aab57c88d3d73164b0730391dfebb7f3e9e3696bb3a124" => :sierra
    sha256 "80e68892a948076affec7e1157924798eb01ae4f15e78103eb2d809cb30aa92c" => :x86_64_linux
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/smalt/smalt_manual.pdf"
    sha256 "efd52e8429237b27797027477c33e1071f6247616d7705106af256e48307480a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    doc.install resource("manual")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smalt version")
  end
end
