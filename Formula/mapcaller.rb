class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.26.tar.gz"
  sha256 "54831c85f7b29fffc0f287978dfb2977d7be15b7c255a1d68bd08b253a032cc7"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d8322737f3dab43b82cdbb7e294a7b3b2033e0bbad475b3526f536db474216b3" => :mojave
    sha256 "f0d93b029986790c5029c48c75ffaeb246ae3c254e5ddc75e66c79f0aceff3ce" => :x86_64_linux
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
