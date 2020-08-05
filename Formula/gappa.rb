class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/v0.6.0.tar.gz"
  sha256 "d11fd5823ab6de4a195e76ff8ecb7f6b36f76c3a6d9e13238d52446ade80ba70"
  license "GPL-3.0"
  head "https://github.com/lczech/gappa.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "1e3a85ebc207e19045898adf2101eaa859dfd778c416e8e7b1fcbe4f51b720d2" => :catalina
    sha256 "6a89712edf8b2ee485daca3e9cce4c18571d480d43aefb4939505212207ca05c" => :x86_64_linux
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
