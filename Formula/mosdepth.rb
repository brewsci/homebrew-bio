class Mosdepth < Formula
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/releases/download/v0.3.1/mosdepth"
  sha256 "ea08b7b59d1a425cf9a0f27681e5f947679c8747eede7b8389e42038fb442618"
  license "MIT"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "28f0f2a6c62cd8543a9f85404c63f861562a25c62dd21bf5c2186d81198be791" => :x86_64_linux
  end

  depends_on :linux

  def install
    bin.install "mosdepth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
    assert_match "BAM-or-CRAM", shell_output("#{bin}/mosdepth -h 2>&1")
  end
end
