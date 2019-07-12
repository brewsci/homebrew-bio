class GmapGsnap < Formula
  # cite Wu_2010: "https://doi.org/10.1093/bioinformatics/btq057"
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2019-06-10.tar.gz"
  sha256 "6b90c09931d0aef36e28c526233054144af32542ae22b079379fcf5f25f58dd1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "25420cf61683ccd854309cb9ba52a78ce99758eea10fa6b96f77e03dbe910d8c" => :sierra
    sha256 "37982e497f6cf41f07afa055ea733490d6c7940c516925426c07badfa45791d3" => :x86_64_linux
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
