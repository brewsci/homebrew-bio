class Gffcompare < Formula
  desc "Classify, merge, tracking and annotation of GFF files"
  homepage "https://github.com/gpertea/gffcompare"
  url "https://github.com/gpertea/gffcompare/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "c708798c873b83b7a3c8e5a779da885b4d24e6039eebc6990d235aa8efe77646"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b488e39ecfb2a697c3efb8f67c7125723ef44c5b0cbfdb097540170960d6ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "980446d510890d9a0edc9868209bce1ca8792d2db8032c61b6bafcb134bc27d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee18a477761276cf8ef0ca9f805caeffc4ea9d4a3bd855c5d5c202e86d3671c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea679fae84071d32e4a59a6739d1e918b3236bd09a124d7636dec1f87c0fcfc5"
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
