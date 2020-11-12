class Sambamba < Formula
  # cite Tarasov_2015: "https://doi.org/10.1093/bioinformatics/btv098"
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba.git",
      tag:      "v0.7.1",
      revision: "851c5b5a9ffe1895d860900104122ab81bb89f21"
  license "GPL-2.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6ddf6f0fc0f344cd7b22b640710f1ee73b0a7edffca2d671188681f99babb297" => :catalina
    sha256 "9f2a305a8b3b6ae83548eefd8766ecde5c7e71b1d7a29fad3c6a52adb70aaaed" => :x86_64_linux
  end

  depends_on "ldc" => :build
  depends_on "python@3.8" => :build

  uses_from_macos "zlib"

  def install
    system "make", "release"
    system "make", "check"
    bin.install "bin/sambamba-#{version}" => "sambamba"
    pkgshare.install "BioD/test/data/ex1_header.bam"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/sambamba --help 2>&1", 1)
    system "#{bin}/sambamba",
      "sort", "-t2", "-n", "#{pkgshare}/ex1_header.bam",
      "-o", "ex1_header.nsorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.nsorted.bam", :exist?
  end
end
