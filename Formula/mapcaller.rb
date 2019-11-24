class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.26.tar.gz"
  sha256 "54831c85f7b29fffc0f287978dfb2977d7be15b7c255a1d68bd08b253a032cc7"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "eedb74839a3457f777d4bd4080d1b8702f4ed8f839ed2e48c2e5ce02cc3ae5b5" => :mojave
    sha256 "1d7d80694d4074e765184ce14e5419b23b9f34a050f050d40ae24da50179e4e3" => :x86_64_linux
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
