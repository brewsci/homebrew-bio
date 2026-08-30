class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6c3e64c6621d1a3ae2ab9f7a3af8d6d130f35e3b260ab659ebf6b60e8364d126"
  license "GPL-3.0-or-later"
  head "https://github.com/lczech/gappa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "c13e763a8ba330babf248274e73edd4c4ae349b1269825de068220f69eda5795"
    sha256 cellar: :any, arm64_sequoia: "dd2f4c9a436058c16599205b0744fa43f60eca466cbf83181fa3ebfb8963ece6"
    sha256 cellar: :any, arm64_sonoma:  "69231c58e821bbcec5012fec240786bcb52f86f06a356e3310c70c0ea95d4d51"
    sha256 cellar: :any, x86_64_linux:  "817c545b0f1694c2dff2e0cf9d23db58a4e89a441a2fa0b051e8fc3f00bf8f98"
  end

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
      system "cmake", "-S", "..", "-B", ".", *std_cmake_args
      system "make"
    end
    bin.install "bin/gappa"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gappa --help")
  end
end
