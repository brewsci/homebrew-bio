class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.2.2.tar.gz"
  sha256 "4042125e7243e03465200bee787e55a54c16c1a10908718af75275c46bfafaad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce10672b7e6a3c586de73fd8e27379edde1b43b35c0ca29523a8ad7acc228715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4c411b2811bed4eaa3975295a930ff9cfd421a24c73cf13ad9f6dc34773cb0"
    sha256 cellar: :any_skip_relocation, ventura:       "ce933414bda9bc886c83cca2938d9d4d604f567e06a6ba1b644c430ccab1ae72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c42984af44df1708bd3186f73bd3ff787c43362ef498a9f4cdd9c46ead1c2c"
  end

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
