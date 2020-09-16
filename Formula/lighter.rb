class Lighter < Formula
  # cite Song_2014: "https://doi.org/10.1186/s13059-014-0509-9"
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/v1.1.2.tar.gz"
  sha256 "89abc34137beffc43382fbe53deb25c3c2f5cee7e6ca2b7f669931d70065993a"
  license "GPL-3.0"
  head "https://github.com/mourisl/Lighter.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0796241a173d658165a7e11203e947339154d31fb35bc7c45408485863525069" => :catalina
    sha256 "126982bdb4ec055ef1aaadc2e968e6f27331e1da78c19c2e044468aa359397e6" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    # Miscompiles with -Os, see https://github.com/mourisl/Lighter/issues/24
    ENV.O2
    system "make"
    bin.install "lighter"
  end

  test do
    assert_match "num_of_threads", shell_output("#{bin}/lighter -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/lighter -v 2>&1")
  end
end
