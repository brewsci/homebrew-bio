class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/v0.6.1.tar.gz"
  sha256 "38d643706b6179347460fb535dbbb07424f38d52e38d631b293484ee1627ac65"
  license "GPL-3.0-or-later"
  head "https://github.com/lczech/gappa.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "086ff9f6e2e67a9143ad7ae5e04f5c1df2141deb2e2ca197956292334c8016f7" => :catalina
    sha256 "2ea3c16aecfd9d8c097fe82fcff5239d0ba82bb3f0d06189cf889c4e98a045e6" => :x86_64_linux
  end

  depends_on "cmake" => :build

  if OS.mac?
    depends_on "gcc"
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install "bin/gappa"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gappa --help")
  end
end
