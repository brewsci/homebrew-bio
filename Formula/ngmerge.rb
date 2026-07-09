class Ngmerge < Formula
  # cite Gaspar_2018: "https://doi.org/10.1186/s12859-018-2579-2"
  desc "Merging paired-end reads and removing adapters"
  homepage "https://github.com/jsh58/NGmerge"
  url "https://github.com/jsh58/NGmerge/archive/refs/tags/v0.5.tar.gz"
  sha256 "bf766185a1b2c41c73ebb22e39163d52965c8df1b1d41b648c58f9b3157f0409"
  license "MIT"
  head "https://github.com/jsh58/NGmerge.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "a5d1f0efe44b04b18bd1c8a0b5acf5a0992dbd34065dd68c911e26ab874228e5"
    sha256 cellar: :any, arm64_sequoia: "b4eac54914da7db49e802ff034a3f5e9753fe2cbf024b5d0b94207f599ff0a21"
    sha256 cellar: :any, arm64_sonoma:  "a1278ca4ceaca066476bc9e4e2e509cb7ef2d75757e40d30c57348fac92a9b54"
    sha256 cellar: :any, x86_64_linux:  "83abeb541fe972333d46f965817696382165ca2c072b13906022b3c219b427d5"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc" # needs openmp
  end

  fails_with :clang # needs openmp

  def install
    system "make"

    pkgshare.install "scripts"
    bin.install "NGmerge"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/NGmerge --help 2>&1", 255)
  end
end
