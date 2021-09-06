class Kollector < Formula
  # cite Kucuk_2017: "https://doi.org/10.1093/bioinformatics/btx078"
  desc "Targeted de novo gene assembly"
  homepage "https://github.com/bcgsc/kollector"
  url "https://github.com/bcgsc/kollector/releases/download/1.0.1/kollector_1.0.1.tar.gz"
  sha256 "8f144d080e8aafdf516f3cafacf0cde8d7bc3b208568211a6533fa7d5027a2fe"
  head "https://github.com/bcgsc/kollector.git", branch: "master"

  depends_on "abyss"
  depends_on "biobloomtools"
  depends_on "bwa"
  depends_on "gmap-gsnap"
  depends_on "samtools"

  def install
    prefix.install Dir["*"]
    bin.install_symlink "kollector.sh" => "kollector"
  end

  test do
    system "#{bin}/kollector", "-h"
  end
end
