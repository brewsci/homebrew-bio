class Roary < Formula
  # cite Page_2015: "https://doi.org/10.1093/bioinformatics/btv421"
  desc "High speed stand alone pan-genome pipeline"
  homepage "https://sanger-pathogens.github.io/Roary/"
  url "https://github.com/sanger-pathogens/Roary/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "375f83c8750b0f4dea5b676471e73e94f3710bc3a327ec88b59f25eae1c3a1e8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "40d2a5579b34f14be8d6fd91f544e4b7b532399a80f51709247e81403ce140ed"
    sha256 cellar: :any,                 ventura:      "d5dcd06d9a05405f1c2e64653e4396b76b72c09e078b8adfbd5cb2552ed33902"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "530c8a2fd8485a6346e3ff2d95d4fb5825facce7f5525db85385732d25639412"
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

  uses_from_macos "libxml2"

  def install
    libexec.install Dir["bin/*"]
    pkgshare.install "contrib"

    # let CPAN install these
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
