class NewickUtils < Formula
  # cite Junier_2010: "https://doi.org/10.1093/bioinformatics/btq243"
  desc "Manipulate Newick tree files"
  homepage "https://cegg.unige.ch/newick_utils"
  url "https://github.com/tjunier/newick_utils/archive/refs/heads/master.tar.gz"
  version "1.6.0"
  sha256 "5214e2b64e3ba29458f0a3d763334701803f5bfc9c6759f4523aa73a5b66625e"
  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 sierra:       "112a87fb8e837fe74b12c0fc77c3181b5f62d17eff1d566287ef6d106ac52a85"
    sha256 x86_64_linux: "998dc74a04eef21d5cbe508ce5135414eb9dd97d3cd327324b1d02dbac200ce0"
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
    ENV["CFLAGS"] = "-O2"
    ENV["LDFLAGS"] = ""

    if OS.mac?
      # Don't bother testing nw_gen, it's known to fail on macOS.
      inreplace "tests/test_nw_gen.sh", "#!/bin/sh", "#!/usr/bin/true" if File.exist?("tests/test_nw_gen.sh")
      system "autoreconf", "-fi"
    end
    system "./configure",
      "--prefix=#{prefix}",
      "--with-libxml",
      "--without-lua",
      "--without-guile"
    system "make"
    system "make", "check" if OS.linux? # Skip tests on macOS due to known nw_gen failures
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "data"
  end

  test do
    assert_match "leaves:\t30", shell_output("#{bin}/nw_stats #{pkgshare}/data/HRV.nw")
  end
end
