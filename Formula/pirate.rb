class Pirate < Formula
  # cite Bayliss_2019: "https://doi.org/10.1101/598391"
  desc "Pangenome analysis and threshold evaluation toolbox"
  homepage "https://github.com/SionBayliss/PIRATE"
  url "https://github.com/SionBayliss/PIRATE/archive/v1.0.2.tar.gz"
  sha256 "4295f0c3380f1df58fb10792ee8e031c5521e449a6d4e4d289bd8cbf493b33d8"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4e9fe8d9e3cc185c25f3eb012273fddfa1c94b70022260a03c4bd9196ace595d" => :sierra
    sha256 "55e990b75e9fde5b11fd07dcd0289d11ea6e152ba77576de3264284873ab5fc9" => :x86_64_linux
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "cd-hit"
  depends_on "diamond"
  depends_on "fasttree"
  depends_on "mafft"
  depends_on "mcl"
  depends_on "parallel"
  unless OS.mac?
    depends_on "perl"
    depends_on "unzip"
  end

  def install
    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    libexec.install Dir["*"]
    %w[PIRATE].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    exe = bin/"PIRATE"
    assert_match version.to_s, shell_output("#{exe} --version 2>&1")
    assert_match "pangenome", shell_output("#{exe} --help 2>&1")
    system exe, "--check"
  end
end
