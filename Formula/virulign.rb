class Virulign < Formula
  # cite Libin_2018: "https://doi.org/10.1093/bioinformatics/bty851"
  desc "Fast codon-correct alignment and annotation of viral genomes"
  homepage "https://github.com/rega-cev/virulign"
  url "https://github.com/rega-cev/virulign/archive/v1.0.2.tar.gz"
  sha256 "3e6934d5b5f37ff60b3aed94472b8076a6e79ea870f7e0ad5c4208a4d13d3c09"
  license "GPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "aa82baa295f493e1627a4f9a4efc724c966ae4dc52226b65ba4cfda4fd7b9806"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "88d9376e8e85dc9ee5b8328753f3205814ed2721ba07779202fecbb86e2e09e8"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "references"
  end

  test do
    assert_match "Mutation", shell_output("#{bin}/virulign 2>&1")
  end
end
