class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.9.tar.gz"
  sha256 "721eeec861b1d5ad8845f04874bdc4f70e21fd2178182cbc9fb591e9886fc6c0"

  bottle do
    cellar :any
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "bf46a0ff5aa8b86a5b03eed10ee1d4232d1a31a58f85123b06044b2f70209286" => :sierra
    sha256 "584e90f96b88d4dd7ed6afde9a9726f29afcfdf8fa429af810e0cc1b0852fce9" => :x86_64_linux
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bin/MapCaller", "bin/bwt_index"
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
