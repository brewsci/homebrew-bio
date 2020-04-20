class Ngmerge < Formula
  # cite Gaspar_2018: "https://doi.org/10.1186/s12859-018-2579-2"
  desc "Merging paired-end reads and removing adapters"
  homepage "https://github.com/jsh58/NGmerge"
  url "https://github.com/jsh58/NGmerge/archive/v0.2.tar.gz"
  sha256 "9d0410ba48f50209e7e652419b3e5d485f515b71ef535f96151cce2dbfdea0de"
  head "https://github.com/jsh58/NGmerge.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "94c91a6b4728d97272b2ce738f3840636e6c5a00b91dae3584d8c04f8981029d" => :sierra
    sha256 "14aa3ca38df1d4ba671be3adbb249585468355c87950e055060f2066a86d1403" => :x86_64_linux
  end

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  on_macos do
    depends_on "gcc" # needs openmp
  end

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
