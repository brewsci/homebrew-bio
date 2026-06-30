class Mosdepth < Formula
  # cite Pederson_2017: "https://doi.org/10.1093/bioinformatics/btx699"
  desc "Fast BAM/CRAM depth calculator"
  homepage "https://github.com/brentp/mosdepth"
  url "https://github.com/brentp/mosdepth/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "abac67de4547dc5642efd46846044d6b3536d2ca3443b4ca172446edf82eeb42"
  license "MIT"
  head "https://github.com/brentp/mosdepth.git", branch: "master"

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
      passl:"-L#{formula_opt_lib("htslib")} -lhts"
      passl:"-L#{formula_opt_lib("brewsci/bio/d4tools")} -ld4binding"
      passl:"-L#{formula_opt_lib("libdeflate")} -ldeflate"
      passl:"-L#{formula_opt_lib("openssl@3")} -lcrypto -lssl"
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
