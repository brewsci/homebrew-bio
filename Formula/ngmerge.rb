class Ngmerge < Formula
  # cite Gaspar_2018: "https://doi.org/10.1186/s12859-018-2579-2"
  desc "Merging paired-end reads and removing adapters"
  homepage "https://github.com/jsh58/NGmerge"
  url "https://github.com/jsh58/NGmerge/archive/v0.2.tar.gz"
  sha256 "9d0410ba48f50209e7e652419b3e5d485f515b71ef535f96151cce2dbfdea0de"
  head "https://github.com/jsh58/NGmerge.git"

  fails_with :clang # needs OpenMP

  depends_on "gcc" if OS.mac?
  depends_on "zlib" unless OS.mac?

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
