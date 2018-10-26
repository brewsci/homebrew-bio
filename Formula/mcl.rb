class Mcl < Formula
  # cite Enright_2002: "https://doi.org/10.1093/nar/30.7.1575"
  desc "Clustering algorithm for graphs"
  homepage "https://micans.org/mcl"
  url "https://micans.org/mcl/src/mcl-14-137.tar.gz"
  sha256 "b5786897a8a8ca119eb355a5630806a4da72ea84243dba85b19a86f14757b497"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "5620623bbe8674f6c69ab21084b1dae29cfdf7cd07273efe1b9deba8ec6a4db5" => :sierra
    sha256 "8535c8aec04127d0e51bf5c469c2127ec8143ce5afc37c9e038a853ab6fb2a20" => :x86_64_linux
  end

  def install
    bin.mkpath
    system "./configure", "--prefix=#{prefix}", "--enable-blast"
    system "make", "install"
    inreplace bin/"mcxdeblast", "/usr/local/bin/perl -w", "/usr/bin/env perl\nuse warnings;"
    inreplace bin/"clxdo", "/usr/local/bin/perl", "perl"
  end

  test do
    assert_match "iterands", shell_output("#{bin}/mcl -h 2>&1")
  end
end
