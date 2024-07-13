class Pirate < Formula
  # cite Bayliss_2019: "https://doi.org/10.1101/598391"
  desc "Pangenome analysis and threshold evaluation toolbox"
  homepage "https://github.com/SionBayliss/PIRATE"
  url "https://github.com/SionBayliss/PIRATE/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "d5d7e657558eadae301a3198bccfd5ee04daddab1a872049d8a74cb71c35f20b"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "facd878921745ef898e0bba2d3fe115be1a9cc46a36886bc0b135b1e9c3450bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "05b6c3b5fbe5db6c0d8f39dab4b31fd5343bd00db69edb093e4f8cd999f11136"
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
