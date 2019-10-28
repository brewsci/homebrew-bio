class Kalign < Formula
  # cite Lassmann_2009: "https://doi.org/10.1093/nar/gkn1006"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/3.1.tar.gz"
  sha256 "cd10303d7b839b57531e94a87f758921947ebcd47bb7163e525415fa28c1c86b"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalign -V 2>&1")
  end
end
