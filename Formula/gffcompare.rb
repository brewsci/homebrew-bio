class Gffcompare < Formula
  desc "Classify, merge, tracking and annotation of GFF files"
  homepage "https://github.com/gpertea/gffcompare"
  url "https://github.com/gpertea/gffcompare/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "4e01344c533987a0a8227bfcca9d180504c1a1392aa343e1f6b0752341e712cf"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2f54276ea7daef17a81e190e879561bd78bbf21d55f1b4b3e95e5daf451aa002"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a319df4c6334df1792496c3aed4bcfeb411c967510d54110abbb13208eebe37c"
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
    assert_predicate testpath/"examples/gffcmp.transcripts.gtf.tmap", :exist?
  end
end
