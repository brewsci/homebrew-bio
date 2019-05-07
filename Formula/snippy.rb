class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/v4.3.8.tar.gz"
  sha256 "16569aabcca866ca40c20b4f3905448204cdea014ea231b2302e8d739a931b3a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "78a7d3a4cde4431a4fc514d93afdd112be4e7207f0b48b6219c701ce31cdb609" => :sierra
    sha256 "6fabc9cbf069ce99d20b5587457fe1602f98fbbc32e803bdb249673ca64eaa78" => :x86_64_linux
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

  unless OS.mac?
    depends_on "bzip2"
    depends_on "gzip"
    depends_on "perl"
  end

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
