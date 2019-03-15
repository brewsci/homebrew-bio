class Gappa < Formula
  # cite Czech_2018: "https://doi.org/10.1093/bioinformatics/bty767"
  # cite Czech_2018: "https://doi.org/10.1101/346353"
  desc "Genesis Applications for Phylogenetic Placement Analysis"
  homepage "https://github.com/lczech/gappa"
  url "https://github.com/lczech/gappa/archive/v0.2.0.tar.gz"
  sha256 "d3673f2a52ca691543a9ec9ecf21c5444c95249e764b89028db946cda0ec8412"
  head "https://github.com/lczech/gappa.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "70c597a42934a466bc88f926259eab7c3f323b71a03675d06f403205052e0fa0" => :sierra
    sha256 "ef9ea2adc12c1b171acf96414a442907ec0cad78289f08d8ff31d4fbf81d0c4f" => :x86_64_linux
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
