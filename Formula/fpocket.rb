class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.2.3.tar.gz"
  sha256 "62b3da6490eeab0db488f0182150d340de2be0be23f4fd1def9d5846ce724ede"
  license "MIT"

  depends_on "netcdf"
  depends_on "qhull"

  def install
    # fix compilation issue: see https://github.com/Discngine/fpocket/issues/164
    inreplace "src/fparams.c" do |s|
      s.gsub! "char *rest2;", "char *rest2;\nchar residue_string[8000];"
      s.gsub! "strcpy(&residue_string, pt);", "strcpy(residue_string, pt);"
    end
    arch = if OS.mac? && Hardware::CPU.arm?
      "ARCH=MACOSXARM64"
    elsif OS.mac? && Hardware::CPU.intel?
      "ARCH=MACOSXX86_64"
    else
      "ARCH=LINUXAMD64"
    end
    system "make", arch
    bin.install Dir["bin/*pocket"]
  end

  test do
    assert_match "***** POCKET HUNTING BEGINS *****", shell_output("#{bin}/fpocket")
  end
end
