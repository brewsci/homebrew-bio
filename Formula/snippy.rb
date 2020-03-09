class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/v4.6.0.tar.gz"
  sha256 "7264e3819e249387effd3eba170ff49404b1cf7347dfa25944866f5aeb6b11c3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8c0d0939812e84c244a2f87a92d42ae79fa9c001ee3a4ea8f00fefa4dd2fd15b" => :catalina
    sha256 "c7a253e55f63fa2969d95ff81908f7fc61a6b1b09cc46b9d796511071396251b" => :x86_64_linux
  end

  depends_on "bcftools"
  depends_on "bedtools"
  depends_on "bioperl"
  depends_on "bwa"
  depends_on "freebayes"
  depends_on "minimap2"
  depends_on "parallel"
  depends_on "samclip"
  depends_on "samtools"
  depends_on "seqtk"
  depends_on "snp-sites"
  depends_on "snpeff"
  depends_on "vcflib"
  depends_on "vt"

  uses_from_macos "bzip2"
  uses_from_macos "gzip"
  uses_from_macos "perl"

  def install
    # brew will provide proper binaries, but keep noarch scripts
    rm_r "binaries/darwin"
    rm_r "binaries/linux"

    prefix.install Dir["*"]
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    %w[snippy snippy-core snippy-vcf_to_tab snippy-clean_full_aln].each do |script|
      inreplace bin/script, "###LINE_FOR_BREW_CONDA###", "use lib '#{bioperl}';"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snippy --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/snippy-core --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/snippy-vcf_to_tab --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/snippy-clean_full_aln --version 2>&1")
    system "#{bin}/snippy-multi", "--help"
    system "#{bin}/snippy", "--check"
    system "#{bin}/snippy-core", "--check"
  end
end
