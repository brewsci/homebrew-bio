class Pirate < Formula
  # cite Bayliss_2019: "https://doi.org/10.1101/598391"
  desc "Pangenome analysis and threshold evaluation toolbox"
  homepage "https://github.com/SionBayliss/PIRATE"
  url "https://github.com/SionBayliss/PIRATE/archive/v1.0.3.tar.gz"
  sha256 "9dbca21c42215aa3c100bf238febbfb194e369054246434bd40287dda9dc518c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e34974e88ac26d538899b3f86982ee3980cd9ffb40beaf0bb9d7d4d8ad3f67ad" => :catalina
    sha256 "368b2cbe46f9f9450a775c8c861e3661436e2add1858d625c91110d8ae2295ca" => :x86_64_linux
  end

  depends_on "bioperl"
  depends_on "blast"
  depends_on "cd-hit"
  depends_on "diamond"
  depends_on "fasttree"
  depends_on "mafft"
  depends_on "mcl"
  depends_on "parallel"

  uses_from_macos "perl"
  uses_from_macos "unzip"

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
