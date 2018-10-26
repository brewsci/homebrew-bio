class Samblaster < Formula
  # cite Faust_2014: "https://doi.org/10.1093/bioinformatics/btu314"
  desc "Fast duplicate marking in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.24.tar.gz"
  sha256 "72c42e0a346166ba00152417c82179bd5139636fea859babb06ca855af93d11f"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6cbcf31a1f314f12519ca125d28deb931589fceb7b833616b242c44c6c5e8312" => :sierra
    sha256 "41fdd5d3bf09c1a45dc4a4aa4bfd7cee316e582f352bffa0ebe31a103e8dd814" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "samblaster"
    doc.install "SAMBLASTER_Supplemental.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samblaster -h 2>&1")
  end
end
