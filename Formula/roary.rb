class Roary < Formula
  # cite Page_2015: "https://doi.org/10.1093/bioinformatics/btv421"
  desc "High speed stand alone pan-genome pipeline"
  homepage "https://sanger-pathogens.github.io/Roary/"
  url "https://github.com/sanger-pathogens/Roary/archive/v3.12.0.tar.gz"
  sha256 "84cfb86845e8f6c4b13d52b6e8634b9a1289c662d8c6f33310bb4d54ade941bc"

  depends_on "cpanminus" => :build

  depends_on "bedtools"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "cd-hit"
  depends_on "fasttree"
  depends_on "kraken"
  depends_on "libxml2"
  depends_on "mafft"
  depends_on "mcl"
  depends_on "parallel"
  depends_on "prank"

  def install
    libexec.install Dir["bin/*"]
    pkgshare.install "contrib"

    # let CPAN install these
    rm_r buildpath/"lib"
    rm_r buildpath/"t"
    rm_r buildpath/"bin"
    bin.mkpath

    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    # --notest because https://github.com/sanger-pathogens/Roary/issues/386
    system "cpanm", "--notest", "--self-contained", "-l", prefix/"perl5", "Bio::Roary"

    Dir[libexec/"*"].each do |exe|
      name = File.basename exe
      (bin/name).write_env_script(exe, :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  def caveats
    <<~EOS
      The included .R scripts need R and ggplot2 to be installed separately.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roary -w 2>&1")
    assert_match version.to_s, shell_output("#{bin}/roary -a 2>&1")
    assert_match "core", shell_output("#{bin}/roary -h 2>&1")
  end
end
