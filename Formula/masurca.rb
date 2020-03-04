class Masurca < Formula
  # cite Zimin_2013: "https://doi.org/10.1093/bioinformatics/btt476"
  desc "Maryland Super-Read Celera Assembler"
  homepage "https://masurca.blogspot.com/"
  url "https://github.com/alekseyzimin/masurca/releases/download/v3.3.7/MaSuRCA-3.3.7.tar.gz"
  sha256 "52e1b60387d704544151e81bfa3c5ad16f2bd6997f55156aaa6047414b5b14ce"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
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
