class Lighter < Formula
  # cite Song_2014: "https://doi.org/10.1186/s13059-014-0509-9"
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c8a251c410805f82dad77e40661f0faf14ec82dedb3ff717094ba8ff4ef94465"
  license "GPL-3.0-or-later"
  head "https://github.com/mourisl/Lighter.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "190c05f24d314728e07122fe082f9c8f41bef34e9b9634d11278c9b777ee63cf"
    sha256 cellar: :any_skip_relocation, ventura:      "a18af500f31394c1ce37edc0daad76375ee6bdc775d5acc884f642afcbcbed46"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "59e6bd4d4cdaef5a5cb2c5f8276b62bd015a6cac54925f092ab1410bee6a66b9"
  end

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
