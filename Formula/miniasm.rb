class Miniasm < Formula
  # cite Li_2016: "https://doi.org/10.1093/bioinformatics/btw152"
  desc "Ultrafast de novo assembly for long noisy reads"
  homepage "https://github.com/lh3/miniasm"
  url "https://github.com/lh3/miniasm/archive/v0.3.tar.gz"
  sha256 "9b688454f30f99cf1a0b0b1316821ad92fbd44d83ff0b35b2403ee8692ba093d"
  head "https://github.com/lh3/miniasm.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "8af4181f510ce974fd6054c61a682d1c0e3a81849dcfcb26fcc662df9cb061cd" => :sierra
    sha256 "28cd7ae2c914864a0f2c594b24390c137f40f208d7400700ea12295a2dc801fb" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "miniasm", "minidot"
    pkgshare.install Dir["misc/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/miniasm 2>&1", 1)
  end
end
