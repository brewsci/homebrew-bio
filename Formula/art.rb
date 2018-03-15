class Art < Formula
  # cite Huang_2012: "https://doi.org/10.1093/bioinformatics/btr708'
  desc "Simulation tools to generate synthetic NGS reads"
  homepage "https://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm"
  if OS.mac?
    url "https://www.niehs.nih.gov/research/resources/assets/docs/artsrcmountrainier20160605macostgz.tgz"
    version "20160605"
    sha256 "1c467c374ec17b1c2c815f4c24746bece878876faaf659c2541f280fe7ba85f7"
  else
    url "https://www.niehs.nih.gov/research/resources/assets/docs/artsrcmountrainier20160605linuxtgz.tgz"
    version "20160605"
    sha256 "69aede60884eb848de043aae5294274b7ca6348b7384a8380f0ac5a4dfeff488"
  end
  revision 1

  depends_on "gsl"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["gsl"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gsl"].opt_lib}"
    system "./configure", "--prefix=#{prefix}"
    # remove the bundled binaries so they get re-made against our libraries
    system "make", "clean"
    system "make", "install"
    doc.install %w[art_454_README art_SOLiD_README art_illumina_README]
    pkgshare.install %w[examples 454_profiles Illumina_profiles SOLiD_profiles]
  end

  test do
    system "#{bin}/art_illumina | grep 'MiSeq'"
    system "#{bin}/art_SOLiD | grep 'F3-F5'"
    system "#{bin}/art_454 | grep 'FLX'"
  end
end
