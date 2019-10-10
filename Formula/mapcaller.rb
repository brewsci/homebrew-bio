class Mapcaller < Formula
  desc "Combined short-read alignment and variant detection"
  homepage "https://github.com/hsinnan75/MapCaller"
  url "https://github.com/hsinnan75/MapCaller/archive/v0.9.9.17.tar.gz"
  sha256 "9483c4822a2ae6cfad3a818df439644a5052ab79fe664c38f3418820b9f305f1"

  bottle do
    cellar :any
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "9af5d3813875f26d94d39faa5757480acd48264e54fda19ca08586cf29b11447" => :sierra
    sha256 "468f89f13b2ba44ddb98bc9b31782794c0b1d41cfd119083ddee7ed659d66373" => :x86_64_linux
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
