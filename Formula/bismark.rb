class Bismark < Formula
  # cite Krueger_2011: "https://doi.org/10.1093/bioinformatics/btr167"
  desc "Bisulfite read mapper and methylation caller"
  homepage "https://github.com/FelixKrueger/Bismark"
  url "https://github.com/FelixKrueger/Bismark/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "b7e69f8e4893059f73863a8d2835245e70132715fdf49163b453bb7c0a8de61d"
  license "GPL-3.0-or-later"

  # NOTE: Bismark v2 is a Rust rewrite. When livecheck/autobump detects it, the
  # version-bump PR will only change url/sha256 and WILL fail: the v2 tarball
  # has no Perl scripts. It needs a full formula rewrite (depends_on "rust" =>
  # :build, a cargo build, and revised runtime deps) rather than an auto-bump.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b49c0530a8d4928ee65631da18a9ebbda75d8d1d30734d9c7d837c274637763a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b49c0530a8d4928ee65631da18a9ebbda75d8d1d30734d9c7d837c274637763a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b49c0530a8d4928ee65631da18a9ebbda75d8d1d30734d9c7d837c274637763a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55ae7483eb072e30793f747a2a3cff26b73867e136703539a58fbd68e018eb1"
  end

  depends_on "bowtie2"
  depends_on "hisat2"
  depends_on "minimap2"
  depends_on "samtools"
  uses_from_macos "perl"

  def install
    # Scripts locate sibling tools and templates via FindBin's $RealBin (which
    # resolves symlinks), so install everything into libexec and symlink the
    # user-facing executables. The plotly/ directory holds report templates.
    scripts = %w[
      bismark bismark_genome_preparation bismark_methylation_extractor
      deduplicate_bismark bismark2bedGraph coverage2cytosine bismark2report
      bismark2summary bam2nuc filter_non_conversion NOMe_filtering
      methylation_consistency
    ]
    libexec.install scripts, "plotly"
    scripts.each { |s| bin.install_symlink libexec/s }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bismark --version")

    seq = "GAGCTCAAGCTTGGATCCGTCGACCTGCAGGCATGCAAGCTTGAGTATTCTATAGTGTCAC" * 10
    (testpath/"genome/genome.fa").write ">chr1\n#{seq}\n"
    system bin/"bismark_genome_preparation", testpath/"genome"

    (testpath/"reads.fastq").write <<~EOS
      @r1
      GAGTTTAAGTTTGGATTTGTCGATTTGTAGGTATGTAAGTTTGAGTATTTTATAGTGTTAT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    EOS
    system bin/"bismark", "--genome", testpath/"genome", testpath/"reads.fastq", "-o", testpath
    assert_path_exists testpath/"reads_bismark_bt2.bam"
  end
end
