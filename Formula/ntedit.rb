class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.3.3.tar.gz"
  sha256 "46deaf46559c894d92caf57aa8ebbab12007c497b6f56494712571134ddd0a67"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "a4c63a643c870a954b0e478aa53a401e28a6ea1b7de21657d7e71d311cdb59a1" => :catalina
    sha256 "ab5ef6cec1bb0d773ec1ae9992fa53c365af134a450c5bfeb5eaaeea893a4adc" => :x86_64_linux
  end

  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "ntedit"
  end

  test do
    assert_match "Options", shell_output("#{bin}/ntedit --help 2>&1")
  end
end
