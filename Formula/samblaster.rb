class Samblaster < Formula
  # cite Faust_2014: "https://doi.org/10.1093/bioinformatics/btu314"
  desc "Fast duplicate marking in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.26.tar.gz"
  sha256 "6b42a53d64a3ed340852028546693a24c860f236fd70e90c2b24fde9dcc4fd63"
  license "MIT"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f386efb369c83d4cbe591579deed487be0b5ab0a504ec4e89b8f14bc4c72737c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "744611e0d8fbed9705fdfa30fb18c7a35182e9262d229a01f9ec9afe51ab7b25"
  end

  def install
    system "make"
    bin.install "samblaster"
    doc.install "SAMBLASTER_Supplemental.pdf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samblaster -h 2>&1")
  end
end
