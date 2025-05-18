class Psipred < Formula
  # cite Li_2011: "https://doi.org/10.1038/nature10231"
  desc "Protein Secondary Structure Predictor"
  homepage "https://github.com/psipred/psipred"
  url "https://github.com/psipred/psipred/archive/refs/tags/v4.0.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"

  # Freely usable for academic and teaching purposes (research-only license)
  license :cannot_represent

  depends_on "brewsci/bio/blast-legacy"
  depends_on "tcsh"

  def install
    Dir.chdir "src" do
      system "make"
      system "make", "install"
    end

  end

  test do
    system "#{bin}/psmc", "1"
  end
end
