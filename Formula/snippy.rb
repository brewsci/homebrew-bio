class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/v4.3.2.tar.gz"
  sha256 "50bc2a3f506122338eff225d7f4ae9c2c0dfeb407f5bd2dd21b09b8c893ef2eb"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "f6ac739de4b0031052e76b09b294ee5b76642fccabc416734228db6b281c7003" => :sierra
    sha256 "7748a369adad0fc6d581bfdf31854c26015a7c08dddcc5e93155587ac82709b8" => :x86_64_linux
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
