class Crumble < Formula
  desc "Controllable lossy compression of BAM/CRAM files"
  homepage "https://github.com/jkbonfield/crumble"
  url "https://github.com/jkbonfield/crumble/releases/download/v0.9.1/crumble-0.9.1.tar.gz"
  sha256 "f68c568c1bbbbda2963bc503d9720af8f7e9c6f0f935f3b248aa81635ed1a076"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "7e410246c46034874e6812737679b52a096ed932078a0a25a5fc50b1fda4ee35"
    sha256 cellar: :any, x86_64_linux: "1f190dcc641889565cd072f02efd334ed9a23dbcb191c2f5b0a081420de3cbb3"
  end

  depends_on "htslib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{formula_opt_prefix("htslib")}"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/crumble -h")
  end
end
