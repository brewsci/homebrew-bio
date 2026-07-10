class Somalier < Formula
  desc "Relatedness, QC and ancestry checks from BAM/CRAM/VCF"
  homepage "https://github.com/brentp/somalier"
  url "https://github.com/brentp/somalier/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c9f6f543eb56c6804fc065392a380c2f231ad280ca44c6d1b12ce5198c66c451"
  license "MIT"
  head "https://github.com/brentp/somalier.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "cd0b68b1f64de81495fa814ba1832da3e291e6ab8de3af0a573840d8e94dc469"
    sha256 cellar: :any, arm64_sequoia: "758c3d8dc00e5f8853b4309dd89d8ac7c71e9c5f275b1f82f735b8b6cc274ab8"
    sha256 cellar: :any, arm64_sonoma:  "a97a277692d066a3a45a3ac454f3ffa08848fc34dad8c42446ee74c639c5179c"
    sha256 cellar: :any, x86_64_linux:  "a8c26f3d6068e71723da76e481e6877f5bcf72c29931faf36c2447b41a00479e"
  end

  depends_on "nim" => :build
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas" # arraymancer BLAS backend (Accelerate is used on macOS)
  end

  def install
    # Link against Homebrew's htslib instead of dynamically loading it.
    rm buildpath/"nim.cfg" if (buildpath/"nim.cfg").exist?
    (buildpath/"nim.cfg").write <<~EOS
      threads:on
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
    system "nimble", "build", "-Y", "somalier.nimble"
    bin.install "somalier"
  end

  test do
    assert_match "somalier version: #{version}", shell_output("#{bin}/somalier --help 2>&1")
    assert_match "relatedness", shell_output("#{bin}/somalier relate --help 2>&1")
  end
end
