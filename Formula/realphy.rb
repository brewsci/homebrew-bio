class Realphy < Formula
  # cite Berteis_2014: "https://doi.org/10.1093/molbev/msu088"
  desc "Reference sequence Alignment based Phylogeny"
  homepage "https://realphy.unibas.ch/fcgi/realphy"
  url "https://realphy.unibas.ch/downloads/REALPHY_v112_exec.zip"
  version "1.12"
  sha256 "ce6cf85f6b16565eb22b13f5e675a644281ef994cd136e40811de3d06781f0c5"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "5105472e7cb9ff1c7f269f0296d57bf221ba7061b10659ec33b5dcf947ecc61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4598375bc8dc2a4d6b7cde0a99ef0292697aae147687cfd4306de922b1fefc98"
  end

  depends_on "openjdk"

  def install
    jar = "RealPhy_v112.jar"
    libexec.install jar
    bin.write_jar_script libexec/jar, "realphy"
    bin.install_symlink "REALPHY" => "../realphy"
    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/realphy -version 2>&1")
  end
end
