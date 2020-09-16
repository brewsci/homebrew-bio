class Pirate < Formula
  # cite Bayliss_2019: "https://doi.org/10.1101/598391"
  desc "Pangenome analysis and threshold evaluation toolbox"
  homepage "https://github.com/SionBayliss/PIRATE"
  url "https://github.com/SionBayliss/PIRATE/archive/v1.0.4.tar.gz"
  sha256 "ed2bad7d73d5c445f565fd7532265b75dad079594d589ece87ae738b712f6bd3"
  license "GPL-3.0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "feaab3d43e87e689002721f5c5ed97317360abff0dab99b8d71c8bd246002933" => :catalina
    sha256 "3a8e4979d6c6f0609133acdf0d9d87765ec1535feef86954dd612fa9a6052a39" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "brewsci/bio/bioperl"
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
    exe = bin/"PIRATE"
    assert_match version.to_s, shell_output("#{exe} --version 2>&1")
    assert_match "pangenome", shell_output("#{exe} --help 2>&1")
    system exe, "--check"
  end
end
