class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/v4.1.0.tar.gz"
  sha256 "8044aebfc4f73eee7cc5d961882f9b825face526be85d9764e7d4058bfea153d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "94ddd387d241db107e48840032e8ceba5500d5be343fdab1731d3a75cb7df450" => :x86_64_linux
  end

  depends_on "bcftools"
  depends_on "bioperl"
  depends_on "bwa"
  depends_on "emboss"
  depends_on "freebayes"
  depends_on :linux # https://github.com/brewsci/homebrew-bio/pull/348 --check returns 255 :(
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
  end
end
