class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.3.1.tar.gz"
  sha256 "541699e8ee4535aba4646424ab7a9edc92d0882bd8daec247d003dd0737e210c"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "e22a1f097b540564b408dcf2189f30cdc63a5db15f92b82605dfb13ab14446c9" => :mojave
    sha256 "a446acbbf4de038f96329f328276f4c154f0ebdfc59a1fd6ce8b4ed23525be86" => :x86_64_linux
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
