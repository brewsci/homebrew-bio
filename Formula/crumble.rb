class Crumble < Formula
  desc "Controllable lossy compression of BAM/CRAM files"
  homepage "https://github.com/jkbonfield/crumble"
  url "https://github.com/jkbonfield/crumble/releases/download/v0.8.1/crumble-0.8.1.tar.gz"
  sha256 "8f31aee3e5a2e22be1c0020373a4f689d3f82f4fbd3bea1b2c78352ad8372599"

  depends_on "htslib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    # https://github.com/jkbonfield/crumble/issues/4
    assert_match "suspicious", shell_output("#{bin}/crumble -h", 1)
  end
end
