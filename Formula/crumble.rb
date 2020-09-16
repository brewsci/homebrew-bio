class Crumble < Formula
  desc "Controllable lossy compression of BAM/CRAM files"
  homepage "https://github.com/jkbonfield/crumble"
  url "https://github.com/jkbonfield/crumble/releases/download/v0.8.3/crumble-0.8.3.tar.gz"
  sha256 "b1ab503f4c98a83e2c81fec4cf8d951c80957ae05b6a6a19b59ece6caf490c01"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "7e410246c46034874e6812737679b52a096ed932078a0a25a5fc50b1fda4ee35" => :catalina
    sha256 "1f190dcc641889565cd072f02efd334ed9a23dbcb191c2f5b0a081420de3cbb3" => :x86_64_linux
  end

  depends_on "htslib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/crumble -h")
  end
end
