class NewickUtils < Formula
  # cite Junier_2010: "https://doi.org/10.1093/bioinformatics/btq243"
  desc "Manipulate Newick tree files"
  homepage "http://cegg.unige.ch/newick_utils"
  url "http://cegg.unige.ch/pub/newick-utils-1.6.tar.gz"
  sha256 "2c142a2806f6e1598585c8be5afba6d448c572ad21c142e70d6fd61877fee798"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "libxml2"
    depends_on "zlib"
  end

  def install
    # Don't bother testing nw_gen, it's known to fail on macOS.
    inreplace "tests/test_nw_gen.sh", "#!/bin/sh", "#!/usr/bin/true" if OS.mac?

    system "./configure",
      "--prefix=#{prefix}",
      "--with-libxml",
      "--without-lua",
      "--without-guile"
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install "data"
  end

  test do
    assert_match "leaves:\t30", shell_output("#{bin}/nw_stats #{pkgshare}/data/HRV.nw")
  end
end
