class Roary < Formula
  # cite Page_2015: "https://doi.org/10.1093/bioinformatics/btv421"
  desc "High speed stand alone pan-genome pipeline"
  homepage "https://sanger-pathogens.github.io/Roary/"
  url "https://github.com/sanger-pathogens/Roary/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "375f83c8750b0f4dea5b676471e73e94f3710bc3a327ec88b59f25eae1c3a1e8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d18d7980fb51cb8ea30bb96541cb65f6076ceccad5c698808a288768f4e834a9"
    sha256 cellar: :any,                 arm64_sequoia: "c5df50c60db1cc07f01641ac0d775a91fd3bd033e6894951639f83f8286142f5"
    sha256 cellar: :any,                 arm64_sonoma:  "a6607be2670cdf1fc0fb71e3279ea7156ee119489dd075f2a5214a98092b87e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2eb2e28e4471769b4f272f6381f442a5acf5da6f1212245ebf9b72874624ba1"
  end

  depends_on "cpanminus" => :build
  depends_on "bedtools"
  depends_on "bioperl"
  depends_on "blast"
  depends_on "brewsci/bio/cd-hit"
  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/kraken"
  depends_on "brewsci/bio/mcl"
  depends_on "brewsci/bio/prank"
  depends_on "mafft"
  depends_on "openssl@3"
  depends_on "parallel"
  depends_on "perl"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    libexec.install Dir["bin/*"]
    pkgshare.install "contrib"

    # let CPAN install these.
    rm_r buildpath/"lib"
    rm_r buildpath/"t"
    rm_r buildpath/"bin"
    bin.mkpath

    ENV.prepend "PERL5LIB", Formula["perl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"

    # --notest because https://github.com/sanger-pathogens/Roary/issues/386
    system "cpanm", "--notest", "--self-contained", "-l", prefix/"perl5", "Bio::Roary"
    Dir[libexec/"*"].each do |exe|
      name = File.basename exe
      (bin/name).write_env_script(exe, PERL5LIB: ENV["PERL5LIB"])
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
