class Mosdepth < Formula
  # cite Pederson_2017: "https://doi.org/10.1093/bioinformatics/btx699"
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "4becd1e74a81ed590588ed2745ef7f1443d0a5aad35f9880a2d452d56a7227ff"
  license "MIT"
  head "https://github.com/brentp/mosdepth.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "f6b9c535f17ba87c89c374a2cd8b3dc0074a5be8fae367b3dfcece578f6db334"
    sha256 cellar: :any,                 arm64_sonoma:  "6b3d07a358bda492f13e81c2caddc632d13ed16ff92eec02643af16e28e90667"
    sha256 cellar: :any,                 ventura:       "053e7e2bc5c911d75fc2d6139d22bd01965f8a05ed56609ce9eacaa65601aab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6301e7f4c83badb6393379bdc861b7e9b5f412ba2af625b06e026c631ee3f9"
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
