class Snippy < Formula
  desc "Rapid bacterial SNP calling and core genome alignments"
  homepage "https://github.com/tseemann/snippy"
  url "https://github.com/tseemann/snippy/archive/v4.0.5.tar.gz"
  sha256 "9f383763edc6e85cf5ba2cc0f88e94a2de280e97bdc1ed8ea1f5123372aa487b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "7b782fd47d041ac84e33f2cdaccd55e1d5c9225492e2bec7e79038344107a588" => :x86_64_linux
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
    Dir[bin/"snipp*"].each do |script|
      inreplace script, "###LINE_FOR_BREW_CONDA###", "use lib '#{bioperl}';"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snippy --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/snippy-core --version 2>&1")
    system "#{bin}/snippy", "--check"
  end
end
