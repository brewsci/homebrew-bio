class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/isovic/racon"
  url "https://github.com/isovic/racon/releases/download/1.2.1/racon-v1.2.1.tar.gz"
  sha256 "6e4b752b7cb6ab13b5e8cb9db58188cf1a3a61c4dcc565c8849bf4868b891bf8"
  head "https://github.com/isovic/racon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ba98f1a47730fc6cab4f819eb0cacacd3e0aa10acbdb88775a7bde09118d26d1" => :sierra_or_later
    sha256 "c0f237505bec85249b36da290f690716c81e66f1306de609b5d70a312626640b" => :x86_64_linux
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
