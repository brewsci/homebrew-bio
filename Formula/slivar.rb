class Slivar < Formula
  desc "Filter/annotate variants in VCF/BCF with expressions, trios and cohorts"
  homepage "https://github.com/brentp/slivar"
  url "https://github.com/brentp/slivar/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "144475352296b44174f9702c8796c0db16ba78e9125f6cae2b16df0df7156423"
  license "MIT"
  head "https://github.com/brentp/slivar.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "94d441351b055b6283909e90a87ec28c02d71d52558f9a33c6f24a564970b0ca"
    sha256 cellar: :any, arm64_sequoia: "865b0bcbbd670e333b895a992d29e82f398553609aa1eae5a3aa668f682a16d4"
    sha256 cellar: :any, arm64_sonoma:  "ef7fd1613c016e67aeb71508965cf04d1d8f9b0ba29c68fa8a12c1c3bdfac2b8"
    sha256 cellar: :any, x86_64_linux:  "5235245930b919d1d98a60104ef47aac07be5ac8b468e5b8ca6e9f17656e12fc"
  end

  depends_on "nim" => :build
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Upstream nim.cfg statically links (-static), which is unsupported on
    # macOS; replace it with config that links Homebrew's htslib.
    rm buildpath/"nim.cfg" if (buildpath/"nim.cfg").exist?
    (buildpath/"nim.cfg").write <<~EOS
      threads:on
      path:"$projectPath/src"
      passl:"-L#{formula_opt_lib("htslib")} -lhts"
      passl:"-L#{formula_opt_lib("libdeflate")} -ldeflate"
      passl:"-L#{formula_opt_lib("openssl@3")} -lcrypto -lssl"
      passl:"-llzma"
      passl:"-lz"
      passl:"-lbz2"
      passl:"-lcurl"
      passl:"-lpthread"
      passl:"-lm"
      dynlibOverride:"hts"
      define:release
      opt:speed
    EOS
    system "nimble", "build", "-Y", "slivar.nimble"
    bin.install "slivar"
  end

  test do
    # `slivar --help` prints its banner then exits non-zero; capture to a file
    # (its `git` version probe otherwise holds the output pipe open).
    system "sh", "-c", "#{bin}/slivar --help > out.log 2>&1 || true"
    help = (testpath/"out.log").read
    assert_match "slivar version: #{version}", help
    assert_match "expr", help
  end
end
