class Trimmomatic < Formula
  # cite Bolger_2014: "https://doi.org/10.1093/bioinformatics/btu170"
  desc "Flexible read trimming tool for Illumina data"
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip"
  sha256 "d428af42b6c400a2e7ee5e6b4cab490eddc621f949b086bd7dddb698dcf1647c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "dedd79b951aca8ed13d0749b21b3d244fa49452432af215071d42165c65bf496" => :sierra
    sha256 "2617dbd81cd0af508269a9382ec4bfd2a1a97aa38ce30a71c4a27fc341127cb1" => :x86_64_linux
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
