class Gffread < Formula
  desc "GFF/GTF utility providing conversions, filtering, FASTA extraction, and more"
  homepage "https://github.com/gpertea/gffread/"
  url "https://github.com/gpertea/gffread/releases/download/v0.12.7/gffread-0.12.7.tar.gz"
  sha256 "bfde1c857495e578f5b3af3c007a9aa40593e69450eafcc6a42c3e8ef08ed1f5"
  license "MIT"
  head "https://github.com/gpertea/gffread.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6968f01edda35e336aabca0642b279b1bf7f0fd5e92adcb85053d5cd87b2b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c44eef481729ddc5f96880ece56eaeab6967f2ac8f906a4147980e4c788dbf0"
    sha256 cellar: :any_skip_relocation, ventura:       "8436ff2e3f16882a7bd443ea12c099a58a443e7e8711038d6b7f2a6c9608bd75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "204ac3950029564edbef84a248aadcb4fb56dd43716fe0c398677f2444c253ef"
  end

  def install
    system "make", "release", "CXX=#{ENV.cxx}", "LINKER=#{ENV.cxx}"
    bin.install "gffread"
  end

  test do
    resource "annotation.gff" do
      url "https://raw.githubusercontent.com/gpertea/gffread/master/examples/annotation.gff"
      sha256 "0812cb16c718673924c90b42cfd1fc6691c77cfce56d0ca0f37b93d2ea776ad9"
    end
    system "#{bin}/gffread", "--version"
    resource("annotation.gff").stage testpath
    # -E annotation.gff -o ann_simple.gff
    system "#{bin}/gffread", "-E", "annotation.gff", "-o", "ann_simple.gff"
    assert_match "NT_187562.1	BestRefSeq	mRNA	411	68627", File.read("ann_simple.gff")
  end
end
