class Lighter < Formula
  # cite Song_2014: "https://doi.org/10.1186/s13059-014-0509-9"
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c8a251c410805f82dad77e40661f0faf14ec82dedb3ff717094ba8ff4ef94465"
  license "GPL-3.0-or-later"
  head "https://github.com/mourisl/Lighter.git", branch: "master"

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "lighter"
  end

  test do
    assert_match "num_of_threads", shell_output("#{bin}/lighter -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/lighter -v 2>&1")
  end
end
