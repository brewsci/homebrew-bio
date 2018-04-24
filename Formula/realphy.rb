class Realphy < Formula
  # cite Berteis_2014: "https://doi.org/10.1093/molbev/msu088"
  desc "The Reference sequence Alignment based Phylogeny"
  homepage "https://realphy.unibas.ch/fcgi/realphy"
  url "https://realphy.unibas.ch/downloads/REALPHY_v112_exec.zip"
  version "1.12"
  sha256 "ce6cf85f6b16565eb22b13f5e675a644281ef994cd136e40811de3d06781f0c5"

  depends_on :java

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
