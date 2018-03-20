class Pathvisio < Formula
  # cite Kutmon_2015: "https://doi.org/10.1371/journal.pcbi.1004085"
  desc "Extendable Pathway Analysis Toolbox"
  homepage "https://www.pathvisio.org/"
  url "https://www.pathvisio.org/data/releases/3.3.0/pathvisio_bin-3.3.0.zip"
  sha256 "403b10e185061799225e1bf04998827edf87c442f2f872811d306997d8ecf672"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install "LICENSE-2.0.txt", "NOTICE.txt", "pathvisio.jar", "pathvisio.sh"
    bin.write_jar_script libexec/"pathvisio.jar", "pathvisio"
  end

  test do
    assert_match "options", shell_output("#{bin}/pathvisio -h")
  end
end
