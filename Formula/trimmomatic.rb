class Trimmomatic < Formula
  # cite Bolger_2014: "https://doi.org/10.1093/bioinformatics/btu170"
  desc "Flexible read trimming tool for Illumina data"
  homepage "http://www.usadellab.org/cms/?page=trimmomatic"
  url "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip"
  sha256 "2f97e3a237378d55c221abfc38e4b11ea232c8a41d511b8b4871f00c0476abca"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b3252323576db7ff5833ce397c962c1e42e4a95da47f546c77c4e0dfc8d0eadb" => :sierra
    sha256 "a8ef297af91bf7e1ccb35092d054e9aefb2d2cb811a53b53756667a89756a61b" => :x86_64_linux
  end

  depends_on :java

  def install
    cmd = "trimmomatic"
    jar = "#{cmd}-0.39.jar"
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
