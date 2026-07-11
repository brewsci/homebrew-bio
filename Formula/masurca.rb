class Masurca < Formula
  # cite Zimin_2013: "https://doi.org/10.1093/bioinformatics/btt476"
  desc "Maryland Super-Read Celera Assembler"
  homepage "https://masurca.blogspot.com/"
  url "https://github.com/alekseyzimin/masurca/releases/download/v4.1.4/MaSuRCA-4.1.4.tar.gz"
  sha256 "6112d742bac326917a57d02f71494e5de4c6a67c6bbef8de54f842b9d5873d7d"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a71c43c7720af509a9754d0afec8bb28e24a1e751c2e84f4c9d4c3b041a4748"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "jellyfish"
  depends_on :linux
  depends_on "parallel"
  depends_on "perl"
  depends_on "zlib"
  # libz on Linux is provided by zlib-ng-compat; declare it directly so the
  # binary links the brewed libz.so.1 (not the host one) and it is not flagged
  # as an indirect-dependency linkage.
  depends_on "zlib-ng-compat"

  def install
    ENV.append "CXXFLAGS", "-include cstdint" # newer GCC needs explicit <cstdint>
    ENV.deparallelize
    # Respect MAKEFLAGS variable
    inreplace "install.sh", "make -j $NUM_THREADS", "make"
    ENV["DEST"] = libexec
    system "./install.sh"

    bin.install_symlink libexec/"bin/masurca"
    # v4 install.sh generates masurca_config_example.txt (was sr_config_example.txt)
    pkgshare.install "masurca_config_example.txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/masurca --version 2>&1")
    system "#{bin}/masurca", "-h"
  end
end
