class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6c3e64c6621d1a3ae2ab9f7a3af8d6d130f35e3b260ab659ebf6b60e8364d126"
  license "GPL-3.0-or-later"
  head "https://github.com/lczech/gappa.git", branch: "master"

  depends_on "cmake" => :build

  if OS.mac?
    depends_on "gcc"
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
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
