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
    sha256 cellar: :any,                 catalina:     "f11c3f6a73ffa46cf999f120002d0aa145a0a857acfc3e8d112406f3cab97e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5278da6176b6e6cf16049949a3351bc0993c9d4e4393f2666716f4b302d0b5ef"
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
