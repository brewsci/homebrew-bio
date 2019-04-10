class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1101/565374"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.2.0.tar.gz"
  sha256 "0e850e58b0b63d4278c8fbe190afe04091a918ec6d8e3d1aa42a5ad862413254"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "f81c78a0836f9727064122aa7e118fb01c37df843c13bb6b5e001344394c7844" => :sierra
    sha256 "1402f099b915da6af80afddd675bcbcd5a124290c59cb5251dc528f0da193403" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "ntedit"
  end

  test do
    assert_match "Options", shell_output("#{bin}/ntedit --help 2>&1")
  end
end
