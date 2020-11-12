class Snoscan < Formula
  # cite Lowe_1999: "https://doi.org/10.1126/science.283.5405.1168"
  desc "Search for C/D box methylation guide snoRNA genes in a genomic sequence"
  homepage "http://lowelab.ucsc.edu/snoscan/"
  url "http://lowelab.ucsc.edu/software/snoscan-0.9.1.tar.gz"
  sha256 "e6ad2f10354cb0c4c44d46d5f298476dbe250a4817afcc8d1c56d252e08ae19e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4f17ef4945c1abe1fade5e7c8b84c0af114487e950331b43227dabe64cdf6a62" => :sierra
    sha256 "7a29e836a55f23cb203ff35ff3a92de8ec86c65cc84f871b7c2120f07816c19e" => :x86_64_linux
  end

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
