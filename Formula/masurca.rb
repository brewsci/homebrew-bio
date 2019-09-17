class Masurca < Formula
  # cite Zimin_2013: "https://doi.org/10.1093/bioinformatics/btt476"
  desc "Maryland Super-Read Celera Assembler"
  homepage "https://masurca.blogspot.com/"
  url "https://github.com/alekseyzimin/masurca/releases/download/v3.3.4/MaSuRCA-3.3.4.tar.gz"
  sha256 "de96e15e74d233537fddc3d62b59b81677876c874ddc9aef1f55ae2d1c933a1d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "fe478f9c6e92ee3fa9ccc24a42d6930f415cf3ab3dfff6a2d4143e3d3e65f0f2" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "jellyfish"
  depends_on :linux
  depends_on "parallel"
  depends_on "perl"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    # Reduce memory usage on CircleCI
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]
    # Respect MAKEFLAGS variable
    inreplace "install.sh", "make -j $NUM_THREADS", "make"
    ENV["DEST"] = libexec
    system "./install.sh"

    bin.install_symlink libexec/"bin/masurca"
    pkgshare.install "sr_config_example.txt"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
