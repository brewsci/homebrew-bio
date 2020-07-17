class Kma < Formula
  desc "Align long and short reads to redundant sequence databases"
  homepage "https://bitbucket.org/genomicepidemiology/kma"
  url "https://bitbucket.org/genomicepidemiology/kma/get/1.3.2.zip"
  sha256 "0623a8845f710c4081554ee2de10b6b56911349fbab3b60ec59b17d9c9cf262a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fed4f2624a05035d31badaf876b184c4124f4e9cacfe1d926686d4fb911b2a67" => :catalina
    sha256 "1f6dcc45095962f7340a511cb1601098b229f28ba19d9dd0b6e3118c3551a252" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install %w[kma kma_index kma_shm]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kma -v 2>&1")
  end
end
