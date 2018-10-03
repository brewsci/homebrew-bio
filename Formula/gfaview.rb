class Gfaview < Formula
  desc "Manipulate an assembly graph in GFA format"
  homepage "https://github.com/lh3/gfa1"
  url "https://github.com/lh3/gfa1/archive/2faeed2953399102e8bb22f5aa833c8f900a7587.tar.gz"
  version "0.0.53"
  sha256 "0f12908a48ad7d9b3fd7b9b32d0d3c8fa2c672c14317085c7a5fb96aef18a4b5"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "gfaview"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gfaview 2>&1", 1)
  end
end
