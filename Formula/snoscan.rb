class Snoscan < Formula
  # cite "https://doi.org/10.1126/science.283.5405.1168"
  desc "Search for C/D box methylation guide snoRNA genes in a genomic sequence"
  homepage "http://lowelab.ucsc.edu/snoscan/"
  url "http://lowelab.ucsc.edu/software/snoscan-0.9.1.tar.gz"
  sha256 "e6ad2f10354cb0c4c44d46d5f298476dbe250a4817afcc8d1c56d252e08ae19e"

  def install
    perl = OS.mac? ? "#!/usr/bin/perl" : "#!/usr/bin/env perl"
    inreplace "sort-snos", "#! /usr/local/bin/perl", perl

    # Delete 0 byte sized files included in the archive.
    system "make", "clean"
    system "make", "-C", "squid-1.5.11"
    system "make"
    bin.install "snoscan", "sort-snos"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/snoscan -h")
    assert_match "Usage", shell_output("#{bin}/sort-snos 2>&1", 255)
  end
end
