class Gffcompare < Formula
  desc "Classify, merge, tracking and annotation of GFF files"
  homepage "https://github.com/gpertea/gffcompare"
  if OS.mac?
    url "https://github.com/gpertea/gffcompare/releases/download/v0.11.7/gffcompare-0.11.7.OSX_x86_64.tar.gz"
    sha256 "5637f81d841c6edce15438b275ba6677a706b9b6e9bacc83f2f61c8310e910c2"
  else
    url "https://github.com/gpertea/gffcompare/releases/download/v0.11.7/gffcompare-0.11.7.Linux_x86_64.tar.gz"
    sha256 "9d90f832cf017b9071a2f247ba7bd30627435a60fa51176b384e3cdc9613099d"
  end
  version "0.11.7"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git"

  def install
    if build.head?
      ENV.deparallelize
      system "make", "release"
    end
    bin.install "gffcompare", "trmap"
    doc.install "LICENSE", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gffcompare --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/trmap --help 2>&1")
  end
end
