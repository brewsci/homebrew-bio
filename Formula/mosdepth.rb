class Mosdepth < Formula
  # cite Pederson_2017: "https://doi.org/10.1093/bioinformatics/btx699"
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "9171ea9a6ddaccd0091db5b85fa9e6cb79516bbe005c47ffc8dcfe49c978eb69"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "af6103cef2557c8713f613f434d5304b6a785fc48dbcb665165a85d2aa7b0099"
    sha256 cellar: :any,                 ventura:      "2e354b459f5c1052699c78c851feb88f2fddf84cdb2c062e1d1dfe568f7f8329"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "287fef1d12d212f6dc764a358b5f6b9d726be51770b60b5ed51228c93f31fef3"
  end

  depends_on "nim" => :build
  depends_on "brewsci/bio/d4tools"
  depends_on "bwa"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # make nim.cfg for Homebrew
    rm buildpath/"nim.cfg"
    (buildpath/"nim.cfg").write <<~EOS
      passl:"-L#{Formula["htslib"].opt_lib} -lhts"
      passl:"-L#{Formula["brewsci/bio/d4tools"].opt_lib} -ld4binding"
      passl:"-L#{Formula["libdeflate"].opt_lib} -ldeflate"
      passl:"-L#{Formula["openssl@3"].opt_lib} -lcrypto -lssl"
      passl:"-llzma"
      passl:"-lz"
      passl:"-lbz2"
      passl:"-lcurl"
      passl:"-lpthread"
      passl:"-lm"
      dynlibOverride:"hts"
      dynlibOverride:"bz2"
      dynlibOverride:"pthread"
      define:release
      opt:speed
      threads:on
    EOS
    system "nimble", "build", "-Y", "mosdepth.nimble"
    bin.install "mosdepth"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mosdepth --version 2>&1")
    assert_match "BAM-or-CRAM", shell_output("#{bin}/mosdepth -h 2>&1")
  end
end
