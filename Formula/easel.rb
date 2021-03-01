class Easel < Formula
  desc "Multiple sequence alignment toolset"
  homepage "https://github.com/EddyRivasLab/easel"
  url "https://github.com/EddyRivasLab/easel/archive/easel-0.46.tar.gz"
  sha256 "6648ab45346c2cef4a5d4086de8e43e44f0c0f367cf92df08f4f9c88c179da42"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/easel[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "c0ad8899059f44836c4358008f6ab0f8c0ab450dedb6dcd032c01dbf23c01e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3721d487dd864d06b3816fb8dc73c62747f881e64b441b844c6e6e29d894cc4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
