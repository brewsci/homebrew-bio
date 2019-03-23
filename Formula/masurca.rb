class Masurca < Formula
  # cite Zimin_2013: "https://doi.org/10.1093/bioinformatics/btt476"
  desc "Maryland Super-Read Celera Assembler"
  homepage "https://masurca.blogspot.com/"
  url "https://github.com/alekseyzimin/masurca/releases/download/v3.3.1/MaSuRCA-3.3.1.tar.gz"
  sha256 "587d0ee2c6b9fbd3436ca2a9001e19f251b677757fe5e88e7f94a0664231e020"

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "jellyfish"
  depends_on :linux
  depends_on "parallel"
  depends_on "perl"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

  def install
    ENV.deparallelize

    ENV["DEST"] = libexec
    system "./install.sh"

    bin.install_symlink libexec/"bin/masurca"
    pkgshare.install "sr_config_example.txt"
  end

  test do
    system "#{bin}/masurca", "-h"
  end
end
