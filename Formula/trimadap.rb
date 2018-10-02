class Trimadap < Formula
  desc "Fast but inaccurate adapter trimmer for Illumina reads"
  homepage "https://github.com/lh3/trimadap"
  url "https://github.com/lh3/trimadap/archive/0.1.tar.gz"
  sha256 "553069d81004b120d9df7d6161edce9317c0f95e5eefe2ec3325dd4081a90acd"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "259c8475ea71102a0d57aa374c7ae296aa5ca6b5ec5c500fe72de0b5db396c35" => :sierra_or_later
    sha256 "a643ca2ca68cda607e4bd48ae1e806a27784b6b7a131e38f5311193c916a3e1b" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "trimadap-mt"
    doc.install "illumina.txt", "test.fa"
    bin.install_symlink "trimadap-mt" => "trimadap"
  end

  test do
    assert_match /^1 +ATCTCGTATGCCGTCTTCTGCTTG$/, shell_output("#{bin}/trimadap #{doc}/test.fa 2>&1")
  end
end
