class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.2.2.tar.gz"
  sha256 "a6273a74b74ad21d76a643e8422ff917c62beee0193779858a6065c322b847fb"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    cellar :any
    sha256 "2ba8df7fc9c2de6072834cc2d0455cc23c1afe7869ffd177d8674d8eb3c49288" => :sierra
    sha256 "60004945f186ea293feb6007e362fdf7af5928cc45865a218f622906eae3e624" => :x86_64_linux
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
