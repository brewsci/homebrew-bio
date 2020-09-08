class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
<<<<<<< HEAD
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.38.tar.gz"
  sha256 "266e8968b2283f17afbc9248f6999d07c203b04efabac34591a6ccb461a07126"
=======
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.39.tar.gz"
  sha256 "554c1d4fd1d2978ddcc657e758bc052874d31421cada2124e42f62588b527578"
  license "MIT"
>>>>>>> upstream/develop

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
<<<<<<< HEAD
    sha256 "e3ea40daeea663d7f9e08c1a44f79b6ce161d94238774508e8856d5805c1c01f" => :catalina
    sha256 "f0deb980cb0f6a4bc14df5aa013e26824a1e2a66279347d79ac90150fc5b08a7" => :x86_64_linux
=======
    sha256 "a1b5b8de122ebbfbfcfd68dcd2c33f10c2df5874993c1eb895ef762a5f923c8a" => :catalina
    sha256 "1078f7ff4afb2ecf4ffa4d022358d344301467134e4eff8fcdcfbc637643078d" => :x86_64_linux
>>>>>>> upstream/develop
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
