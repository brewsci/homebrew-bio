class Wiggletools < Formula
  # cite Zerbino_2013: "https://doi.org/10.1093/bioinformatics/btt737"
  desc "Compute genome-wide statistics with composable iterators"
  homepage "https://github.com/Ensembl/WiggleTools"
  url "https://github.com/Ensembl/WiggleTools/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "ba239c55d017c5d7fd7e11ebf827a1caf3e504bf61bdcd511cd9342da0e94005"
  license "Apache-2.0"
  head "https://github.com/Ensembl/WiggleTools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "0a38a3e0270bdb648672f6d98c488bae292aa2f49da7f6c2ef9b61cb48b27008"
    sha256 cellar: :any,                 ventura:      "5c1c1092538ad14e5459d69558ec8ae037a54aeff12f98dc7ac3b4e30bf3fdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd4c1dfcf35e55dc6315d180fa15309dfd45688549a0521748023b8cbf7016f8"
  end

  depends_on "python@3.12" => :test
  depends_on "brewsci/bio/libbigwig"
  depends_on "gsl"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make"
    pkgshare.install "test"
    lib.install "lib/libwiggletools.a"
    bin.install "bin/wiggletools"
  end

  test do
    assert_match "Command line", shell_output("#{bin}/wiggletools --help")

    if which "python3.12"
      cp_r pkgshare/"test", testpath
      cp_r prefix/"bin", testpath
      cd "test" do
        system "python3.12", "test.py"
      end
    end
  end
end
