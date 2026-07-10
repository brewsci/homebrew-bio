class Slivar < Formula
  desc "Filter/annotate variants in VCF/BCF with expressions, trios and cohorts"
  homepage "https://github.com/brentp/slivar"
  url "https://github.com/brentp/slivar/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "144475352296b44174f9702c8796c0db16ba78e9125f6cae2b16df0df7156423"
  license "MIT"
  head "https://github.com/brentp/slivar.git", branch: "master"

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
