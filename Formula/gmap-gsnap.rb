class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2018-07-04.tar.gz"
  sha256 "a9f8c1f0810df65b2a089dc10be79611026f4c95e4681dba98fea3d55d598d24"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "f39654d9dad269ab406326fdb51c4b0ec55d930711c5c8484b7d6845248d2038" => :sierra_or_later
    sha256 "68bddc2d4a3b28f6dceae1809c9ede40e8c49bcdf678f2ad9a0195a7fb34276c" => :x86_64_linux
  end

  depends_on "samtools"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<~EOS
    You will need to either download or build indexed search databases.
    See the readme file for how to do this:
      http://research-pub.gene.com/gmap/src/README

    Databases will be installed to:
      #{share}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsnap --version 2>&1")
  end
end
