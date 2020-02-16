class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.37.tar.gz"
  sha256 "4cc83e071edbe4310f75eade2f874c8dd11a848909fe6f0706a4badf5bae1898"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "0f7b021dd4032f2b4596fddf4613f32b76cd1e30eac7f2f6de8251c62c50ca46" => :catalina
    sha256 "cf0d7297eb1ed30044e49f5de863ed1dc59f4dd3c38fc51efa5499fabdcc561d" => :x86_64_linux
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
