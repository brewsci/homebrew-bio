class Ngmerge < Formula
  # cite Gaspar_2018: "https://doi.org/10.1186/s12859-018-2579-2"
  desc "Merging paired-end reads and removing adapters"
  homepage "https://github.com/jsh58/NGmerge"
  url "https://github.com/jsh58/NGmerge/archive/v0.3.tar.gz"
  sha256 "5928f727feebd0d1bcdbee0e631ba06fbe9ce88328bd58b6c8bf4e54cc742ac3"
  license "MIT"
  head "https://github.com/jsh58/NGmerge.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "d24a87d8ef03468e83a8ef10a594a4c3bf9588945a1c817294d8b831d704cc59" => :catalina
    sha256 "57587c4834b4ba04d472b69f0ccfa92ebf1f068c27b43ba21fe165fe06dbe52f" => :x86_64_linux
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc" # needs openmp
  end

  fails_with :clang # needs openmp

  def install
    system "make"

    pkgshare.install "scripts"
    doc.install "UserGuide.pdf"
    bin.install "NGmerge"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/NGmerge --help 2>&1", 255)
  end
end
