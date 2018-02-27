class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.0.1/racon-v1.0.1.tar.gz"
  sha256 "6da26c3fbc4a3257edc547025613c32ca4daa0b51e2a263aa4e86e72907ea577"
  head "https://github.com/isovic/racon.git"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "11f4cb3b08cc8c85379206380ca31c6d3080c0ad2d57cf3521b205c696da025a" => :sierra_or_later
    sha256 "e0ddcba858fd4fea2ee153095acf409ff18c4544c029a71907da4eae285a753b" => :x86_64_linux
  end

  needs :cxx11
  fails_with :clang # needs openmp

  depends_on "cmake" => :build
  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
