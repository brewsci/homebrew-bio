class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.3.2.tar.gz"
  sha256 "acbd491416efb6c6ba17fe7ed3d11b62ca352f6b55713044859728c464ed00dc"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "ca1bc15d3add4caff031d05c1aaac1f72140b779ac2358cde0d6b6eef86ac4f9" => :catalina
    sha256 "d030be57e3e285fd2921bdf235eff946a6b4a87fd424da0c4a38cc11da719e45" => :x86_64_linux
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
