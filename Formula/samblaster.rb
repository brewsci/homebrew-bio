class Samblaster < Formula
  # cite Faust_2014: "https://doi.org/10.1093/bioinformatics/btu314"
  desc "Fast duplicate marking in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.24.tar.gz"
  sha256 "72c42e0a346166ba00152417c82179bd5139636fea859babb06ca855af93d11f"
  head "https://github.com/GregoryFaust/samblaster"

  def install
    system "make"
    bin.install "samblaster"
    doc.install "SAMBLASTER_Supplemental.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samblaster -h 2>&1")
  end
end
