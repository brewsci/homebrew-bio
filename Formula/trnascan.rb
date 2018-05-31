class Trnascan < Formula
  # cite Lowe_1997: "https://doi.org/10.1093/nar/25.5.0955"
  desc "Search for tRNA genes in genomic sequence"
  homepage "http://lowelab.ucsc.edu/tRNAscan-SE/"
  url "http://lowelab.ucsc.edu/software/tRNAscan-SE-1.3.tar.gz"
  sha256 "c40d05bbaa9d6efbfc0e447f8ac521e3b4067fab4b64a351c0763a3f41f6581f"
  version_scheme 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "a54b3d2b603962584f862f25c1a385bd38653d1b691df8ece20319e6f0848e27" => :sierra_or_later
    sha256 "d81fc3713ae3db57312729afa507a2858a9c406107fd130b0a5ada21c7db01b3" => :x86_64_linux
  end

  def install
    inreplace "tRNAscan-SE.src", "use strict;", "use strict;\nuse lib \"#{prefix}\";"
    system "make", "all", "install", "CFLAGS=-D_POSIX_C_SOURCE=1", "BINDIR=#{bin}", "LIBDIR=#{libexec}", "MANDIR=#{man}"
    prefix.install bin/"tRNAscanSE"
    prefix.install "Demo"
    (prefix/"Demo/testrun.ref").write <<~EOS
      Sequence 		tRNA 	Bounds	tRNA	Anti	Intron Bounds	Cove	Hit
      Name     	tRNA #	Begin	End  	Type	Codon	Begin	End	Score	Origin
      -------- 	------	---- 	------	----	-----	-----	----	------	------
      CELF22B7 	1	12619	12738	Leu	CAA	12657	12692	60.01	Bo
      CELF22B7 	2	19480	19561	Ser	AGA	0	0	80.44	Bo
      CELF22B7 	3	26367	26439	Phe	GAA	0	0	80.32	Bo
      CELF22B7 	4	26992	26920	Phe	GAA	0	0	80.32	Bo
      CELF22B7 	5	23765	23694	Pro	CGG	0	0	75.76	Bo
    EOS
  end

  test do
    system "#{bin}/tRNAscan-SE", "-d", "-y", "-o", "test.out", "#{prefix}/Demo/F22B7.fa"
    assert_predicate testpath/"test.out", :exist?
    assert_equal File.read("test.out"), File.read(prefix/"Demo/testrun.ref")
  end
end
