class Pirate < Formula
  # cite Bayliss_2019: "https://doi.org/10.1101/598391"
  desc "Pangenome analysis and threshold evaluation toolbox"
  homepage "https://github.com/SionBayliss/PIRATE"
  url "https://github.com/SionBayliss/PIRATE/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d5d7e657558eadae301a3198bccfd5ee04daddab1a872049d8a74cb71c35f20b"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "f9c3d3f37065a05791b6c561888fbe9e3f532320a45c312018ae4130cd3fb853"
    sha256 cellar: :any_skip_relocation, ventura:      "f9c3d3f37065a05791b6c561888fbe9e3f532320a45c312018ae4130cd3fb853"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a810a4b27460809759ab9c9f2a62a4d58660b6281c9fd87a92b0cbc981c9883"
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "brewsci/bio/cd-hit"
  depends_on "brewsci/bio/fasttree"
  depends_on "brewsci/bio/mcl"
  depends_on "diamond"
  depends_on "mafft"
  depends_on "parallel"

  uses_from_macos "perl"
  uses_from_macos "unzip"

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    libexec.install Dir["*"]
    %w[PIRATE].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/PIRATE --version 2>&1")
    assert_match "pangenome", shell_output("#{bin}/PIRATE --help 2>&1")
    system "#{bin}/PIRATE", "--check"
  end
end
