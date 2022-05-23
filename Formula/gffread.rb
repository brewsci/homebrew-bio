class Gffread < Formula
  desc "GFF/GTF utility providing format conversions, region filtering, FASTA sequence extraction and more"
  homepage "https://github.com/gpertea/gffread/"
  url "https://github.com/gpertea/gffread/releases/download/v0.12.7/gffread-0.12.7.tar.gz"
  sha256 "bfde1c857495e578f5b3af3c007a9aa40593e69450eafcc6a42c3e8ef08ed1f5"
  license "MIT"

  def install
    system "make", "release"
    bin.install "gffread"
  end

  test do
    system "#{bin}/gffread", "--version"
  end
end
