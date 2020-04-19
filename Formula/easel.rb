class Easel < Formula
  desc "Multiple sequence alignment toolset"
  homepage "https://github.com/EddyRivasLab/easel"
  url "https://github.com/EddyRivasLab/easel/archive/easel-0.46.tar.gz"
  sha256 "6648ab45346c2cef4a5d4086de8e43e44f0c0f367cf92df08f4f9c88c179da42"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "88436bd5340a4202a0a2a769226a97456d695883d2e97a8e4aa64e0e2560891b" => :sierra
    sha256 "d7f95fcf20e465bb25b27bd1bd19631fe3bd636d5e415d8665e660c0a2fd8ad6" => :x86_64_linux
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "esl_msa_testfiles"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esl-weight -h")
    assert_match "<msafile>", shell_output("#{bin}/esl-afetch -h")
    assert_match "Alignment length:    165",
      shell_output("#{bin}/esl-alistat #{pkgshare}/esl_msa_testfiles/afa/afa.good.1")
  end
end
