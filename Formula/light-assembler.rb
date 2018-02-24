class LightAssembler < Formula
  desc "Lightweight resources NGS assembly algorithm"
  homepage "https://github.com/SaraEl-Metwally/LightAssembler"
  url "https://github.com/SaraEl-Metwally/LightAssembler/archive/v1.0.0.tar.gz"
  sha256 "a04807a761d932fcef29c2d05cac9030fe325689e2e6b64e415873e69712c379"
  head "https://github.com/SaraEl-Metwally/LightAssembler.git"
  # cite El-MetWally_2016: "https://doi.org/10.1093/bioinformatics/btw470"

  depends_on "zlib" unless OS.mac?

  def install
    system "make", "k=127"
    bin.install "LightAssembler"
  end

  test do
    assert_match "LightAssembler", shell_output("#{bin}/LightAssembler 2>&1", 1)
  end
end
