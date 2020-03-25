class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/lbcb-sci/racon"
  url "https://github.com/lbcb-sci/racon/releases/download/1.4.10/racon-v1.4.10.tar.gz"
  sha256 "016fb3affb977303a5f5ad27339a7044fa3d9b89a6ea3c7734479f864155a0c2"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6ab2eda0ac6f54a9096972bea2b413d2d692bceb28b090eb97571ed02531e2b4" => :catalina
    sha256 "42aba44f505ae524b7e7aa22827994db66495c76caa35caea938286dda6be851" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # needs openmp
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
