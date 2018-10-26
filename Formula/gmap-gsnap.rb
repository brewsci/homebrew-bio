class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2018-07-04.tar.gz"
  sha256 "a9f8c1f0810df65b2a089dc10be79611026f4c95e4681dba98fea3d55d598d24"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d3f2ddc81b616b01ea9e2f1857f0ff1d64e49d35361661b579ec36420b60f963" => :sierra
    sha256 "b336ad0183f34f685d8e3e83961499a1da2e616637f04447408f1758ef8e9729" => :x86_64_linux
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
