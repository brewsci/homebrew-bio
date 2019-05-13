class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/v0.4.0.tar.gz"
  sha256 "14470272ba00d0b0b4d7a3fd67e07c93c6af8fbe6f9d1a6a76d349080d81a860"
  head "https://github.com/lczech/gappa.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3631e901f4c8036bf29556d131cee2df52912c6d5494ba4d3b69090af12c8929" => :sierra
    sha256 "3010aa16e49c604ad5bdee5101723e6672a130e67e31dd8aa98de245557cb795" => :x86_64_linux
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
