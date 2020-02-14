class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.34.tar.gz"
  sha256 "ee00c0569390e573b2cc3af62704f079bada1e61ba548b55079ec433d8b0bf64"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "7ae8badb8bc4f838e672099073035d6f53c9b1fca8e0d9fe080dafeb0b88539f" => :catalina
    sha256 "3a606b183f875dbe99e6c590a2e189f7c025d0ada1bfdf57446946aeab276358" => :x86_64_linux
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    assert_predicate testpath/"out.vcf", :exist?
  end
end
