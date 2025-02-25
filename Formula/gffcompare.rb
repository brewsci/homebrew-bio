class Gffcompare < Formula
  desc "Classify, merge, tracking and annotation of GFF files"
  homepage "https://github.com/gpertea/gffcompare"
  url "https://github.com/gpertea/gffcompare/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "4e01344c533987a0a8227bfcca9d180504c1a1392aa343e1f6b0752341e712cf"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "12efb3fc54031b11d10495f7e5f43b498dbdc1be73325ee5155fbda1a3042680"
    sha256 cellar: :any_skip_relocation, ventura:      "60eb9381af143dbebb860aede53370c6cc1bcd959112b5c22dcb0451f351ec09"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e78c42ed6290d95bbbf0cc0442a2ba95f8a350e289665d5dbbdb96a0c24a218b"
  end

  def install
    ENV.deparallelize
    system "make", "release"
    bin.install "gffcompare", "trmap"
    doc.install "LICENSE", "README.md"
    prefix.install "examples"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gffcompare --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/trmap --help 2>&1")
    cp_r prefix/"examples", testpath
    system "#{bin}/gffcompare", "-r", "#{testpath}/examples/annotation.gff",
                                      "#{testpath}/examples/transcripts.gtf"
    assert_path_exists testpath/"examples/gffcmp.transcripts.gtf.tmap"
  end
end
