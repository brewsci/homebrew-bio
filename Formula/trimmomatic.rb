class Trimmomatic < Formula
  # cite Bolger_2014: "https://doi.org/10.1093/bioinformatics/btu170"
  desc "Flexible read trimming tool for Illumina data"
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip"
  sha256 "d428af42b6c400a2e7ee5e6b4cab490eddc621f949b086bd7dddb698dcf1647c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0a97beba1eb0e3808ea1cc7cd36193170783884e084513a9d0a700f851d6345d" => :sierra_or_later
  end

  depends_on :java

  def install
    cmd = "trimmomatic"
    jar = "#{cmd}-0.38.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, cmd
    pkgshare.install "adapters"
  end

  def caveats
    <<~EOS
      FASTA file of adapter sequences are located here:
      #{pkgshare}/adapters
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trimmomatic -version 2>&1")
  end
end
