class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/refs/tags/v0.9.9.41.tar.gz"
  sha256 "f1630d7c9243e70e33b244e3dfdb3ffa2a9836cea37fd2f8b49044dea029b12f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "a1b5b8de122ebbfbfcfd68dcd2c33f10c2df5874993c1eb895ef762a5f923c8a"
    sha256 cellar: :any, x86_64_linux: "1078f7ff4afb2ecf4ffa4d022358d344301467134e4eff8fcdcfbc637643078d"
  end

  depends_on "xz"
  depends_on "zlib-ng-compat"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  def install
    system "make"
    bin.install "bin/MapCaller"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/MapCaller -v 2>&1")
    system bin/"MapCaller", "index", pkgshare/"test/ref.fa", testpath/"ref"
    system bin/"MapCaller", "-i", testpath/"ref",
                            "-f", pkgshare/"test/r1.fq",
                            "-f2", pkgshare/"test/r2.fq",
                            "-vcf", testpath/"out.vcf",
                            "-t", "2"
    assert_path_exists testpath/"out.vcf"
  end
end
