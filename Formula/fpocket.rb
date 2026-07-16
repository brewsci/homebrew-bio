class Fpocket < Formula
  desc "Protein pocket detection algorithm based on Voronoi tessellation"
  homepage "https://github.com/Discngine/fpocket"
  url "https://github.com/Discngine/fpocket/archive/refs/tags/4.2.3.tar.gz"
  sha256 "62b3da6490eeab0db488f0182150d340de2be0be23f4fd1def9d5846ce724ede"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9246e9c4af3ed7d718ce791a349b7df59991aae10f67af86a6128504a0e06bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ccb39b48d1973fac244d7d2dc8d88bd8031ffb5b8e78c1dbfededabe6231c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e05d7ccfe9bfe05e617cc33c2a2f63d6006f4a9e5984791742c6e518d8d7c28"
    sha256 cellar: :any,                 x86_64_linux:  "f6034926c065520bf76f5ce3f847c44eadc661e4505891983f68e244dc29b98a"
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
