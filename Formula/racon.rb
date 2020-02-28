class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/lbcb-sci/racon"
  url "https://github.com/lbcb-sci/racon/releases/download/1.4.10/racon-v1.4.10.tar.gz"
  sha256 "016fb3affb977303a5f5ad27339a7044fa3d9b89a6ea3c7734479f864155a0c2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e174c78ccd648b764b57e1040f94a6b50e6e752c69855f4080619393b96f3282" => :catalina
    sha256 "d9632f03a85e84312928de0c2b302d4aa79edc1c250bc24eb17e00ea8152fbdc" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # for openmp
  depends_on "python"

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    bin.install Dir["scripts/*.py"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/racon --version 2>&1")
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
