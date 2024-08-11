class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "7264e3819e249387effd3eba170ff49404b1cf7347dfa25944866f5aeb6b11c3"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "8c0d0939812e84c244a2f87a92d42ae79fa9c001ee3a4ea8f00fefa4dd2fd15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c7a253e55f63fa2969d95ff81908f7fc61a6b1b09cc46b9d796511071396251b"
  end

  depends_on "bcftools"
  depends_on "bedtools"
  depends_on "bioperl"
  depends_on "brewsci/bio/freebayes"
  depends_on "brewsci/bio/samclip"
  depends_on "brewsci/bio/snp-sites"
  depends_on "brewsci/bio/snpeff"
  depends_on "brewsci/bio/vcflib"
  depends_on "brewsci/bio/vt"
  depends_on "bwa"
  depends_on "minimap2"
  depends_on "openjdk@11"
  depends_on "perl"
  depends_on "samtools"
  depends_on "seqtk"

  uses_from_macos "bzip2"
  uses_from_macos "gzip"

  resource "any2fasta" do
    url "https://raw.githubusercontent.com/tseemann/any2fasta/v0.4.2/any2fasta"
    sha256 "ed20e895c7a94d246163267d56fce99ab0de48784ddda2b3bf1246aa296bf249"
  end

  resource "fasta_generate_regions.py" do
    url "https://raw.githubusercontent.com/tseemann/snippy/master/binaries/noarch/fasta_generate_regions.py"
    sha256 "6c688cc748cc48fae99a5274dfb7053f446287af36728f5473c8a54721d221e3"
  end

  def install
    rm_r "binaries"

    ENV.prepend_path "PERL5LIB", Formula["bioperl"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec
    ENV["PERL_MM_USE_DEFAULT"] = "1"

    libexec.install Dir["*"]
    binaries = %w[
      snippy
      snippy-core
      snippy-vcf_to_tab
      snippy-clean_full_aln
      snippy-multi
      snippy-vcf_extract_subs
      snippy-vcf_report
      snippy-vcf_to_tab
    ]
    binaries.each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", JAVA_HOME:  Formula["openjdk@11"].opt_prefix,
                                                            PERL5LIB:   ENV["PERL5LIB"])
    end

    mkdir_p libexec/"binaries/noarch"
    resources.each do |r|
      (libexec/"binaries/noarch").install r
      chmod 0755, libexec/"binaries/noarch/#{r.name}"
    end
    inreplace "#{libexec}/binaries/noarch/fasta_generate_regions.py", "/usr/bin/env python", "/usr/bin/env python3"
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
