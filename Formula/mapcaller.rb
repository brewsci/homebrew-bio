class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.6.tar.gz"
  sha256 "ced5475c154f5d1d9d3d35a0214d2638821e4934daff58d669802e126cf76d30"

  # https://github.com/hsinnan75/MapCaller/issues/9
  depends_on :linux
  depends_on "xz"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
    depends_on "curl"
  end

  def install
    ENV.deparallelize
    system "make"
    bin.install "bwt_index", "MapCaller"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/MapCaller -v 2>&1")
    assert_match "Usage:", shell_output("#{bin}/bwt_index 2>&1")
    system bin/"bwt_index", pkgshare/"test/ref.fa", testpath/"ref"
    system bin/"MapCaller", "-i", testpath/"ref",
                            "-f", pkgshare/"test/r1.fq",
                            "-f2", pkgshare/"test/r2.fq",
                            "-vcf", testpath/"out.vcf",
                            "-t", "2"
    assert_predicate testpath/"out.vcf", :exist?
  end
end
