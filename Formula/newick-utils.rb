class NewickUtils < Formula
  # cite Junier_2010: "https://doi.org/10.1093/bioinformatics/btq243"
  desc "Manipulate Newick tree files"
  homepage "https://cegg.unige.ch/newick_utils"
  url "https://github.com/tjunier/newick_utils/archive/refs/heads/master.tar.gz"
  version "1.6.0"
  sha256 "5214e2b64e3ba29458f0a3d763334701803f5bfc9c6759f4523aa73a5b66625e"
  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4a415f7583486878728bb892242a518c90416633a3b22f3741c8cbaea2f23f72"
    sha256 cellar: :any,                 arm64_sonoma:  "8c8bdda745ff21c68b68715f63930d61459a602ef9aa754919ea0d62c41a2355"
    sha256 cellar: :any,                 ventura:       "b5d21f31755a6b3965698f015424f75ef461a007c96dab3f4b721d14aedda90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7e4d4366238d42384f883eda1fdb8a2c97545e3b2344e5bc4efc9d5adb2a59"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "libxml2"
    depends_on "zlib"
  end

  def install
    # Set environment variables
    ENV["CFLAGS"] = "-O2 -fcommon"
    ENV["LDFLAGS"] = ""

    # Don't bother testing nw_gen, it's known to fail on macOS.
    system "autoreconf", "-fi"
    if OS.mac?
      inreplace "tests/test_nw_gen.sh", "#!/bin/sh", "#!/usr/bin/true" if File.exist?("tests/test_nw_gen.sh")
      system "./configure",
            "--prefix=#{prefix}",
            "--with-libxml",
            "--without-lua",
            "--without-guile"
    end
    if OS.linux?
      system "./configure",
             "--prefix=#{prefix}"
    end
    system "make"
    # system "make", "check" if OS.linux? # Skip tests on macOS and Linux due to known nw_gen and nw_ed failures
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "data"
  end

  test do
    assert_match "leaves:\t30", shell_output("#{bin}/nw_stats #{pkgshare}/data/HRV.nw")
  end
end
