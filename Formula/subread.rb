class Subread < Formula
  # cite Liao_2013: "https://doi.org/10.1093/nar/gkt214"
  desc "High-performance read alignment, quantification and mutation discovery"
  homepage "https://academic.oup.com/nar/article/41/10/e108/1075719"
  url "https://cfhcable.dl.sourceforge.net/project/subread/subread-1.6.4/subread-1.6.4-source.tar.gz"
  sha256 "b7bd0ee3b0942d791aecce6454d2f3271c95a010beeeff2daf1ff71162e43969"

  depends_on "zlib" unless OS.mac?

  def install
    cd "src" do
      if OS.mac?
        system "make", "-f", "Makefile.MacOS"
      else
        system "make", "-f", "Makefile.Linux"
      end

      bin.install Dir["../bin/sub*"]
      bin.install "../bin/exactSNP"
      bin.install "../bin/featureCounts"
      bin.install Dir["../bin/utilities/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/featureCounts -v 2>&1")
  end
end
