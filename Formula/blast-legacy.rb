class BlastLegacy < Formula
  desc "Legacy NCBI BLAST"
  homepage "https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download"
  if OS.mac?
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-universal-macosx.tar.gz"
    sha256 "eabad6b37ded329a7edd14d650e0aedf7b88aa4bd1611a228d5191952d83f3b8"
  else
    url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.26/blast-2.2.26-x64-linux.tar.gz"
    sha256 "8a2f986cf47f0f7cbdb3478c4fc7e25c7198941d2262264d0b6b86194b3d063d"
  end
  # cite Altschul_1990: "https://doi.org/10.1093/nar/25.17.3389"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "cb62bf738ed68725b0711f9259ad4cfb8273d6b445cc3b2dabc0de3c6a9d4af8" => :sierra
    sha256 "bf4932732f4f8a1f174db415e0fee1912e6ceb73b46ef907d44f9ed47df66857" => :x86_64_linux
  end

  def install
    File.rename("bin/rpsblast", "bin/rpsblast.legacy")
    File.rename("bin/seedtop", "bin/seedtop.legacy")
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      Tools 'rpsblast' and 'seedtop' were installed as 'rpsblast.legacy' and 'seedtop.legacy'
      to avoid conflicts with the BLAST+ executables.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blastall", 1)
    assert_match "BLOSUM62", shell_output("#{bin}/blastall 2>&1", 1)
    assert_match "millions", shell_output("#{bin}/formatdb - 2>&1", 1)
    assert_match "NGB00323.1:1-37", shell_output("#{bin}/fastacmd -D 1 -d #{prefix}/data/UniVec_Core")
  end
end
