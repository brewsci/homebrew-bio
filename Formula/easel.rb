class Easel < Formula
  desc "Multiple sequence alignment toolset"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/infernal/infernal-1.1.2.tar.gz"
  # Easel is a sub-folder in Infernal, never officially released separately
  version "0.43"
  sha256 "ac8c24f484205cfb7124c38d6dc638a28f2b9035b9433efec5dc753c7e84226b"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "88436bd5340a4202a0a2a769226a97456d695883d2e97a8e4aa64e0e2560891b" => :sierra
    sha256 "d7f95fcf20e465bb25b27bd1bd19631fe3bd636d5e415d8665e660c0a2fd8ad6" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    cd "easel" do
      system "make"
      system "make", "install"
      pkgshare.install "formats", "esl_msa_testfiles", "testsuite"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esl-weight -h")
    assert_match "<msafile>", shell_output("#{bin}/esl-afetch -h")
    assert_match "Alignment length:    165",
      shell_output("#{bin}/esl-alistat #{pkgshare}/esl_msa_testfiles/afa/afa.good.1")
  end
end
