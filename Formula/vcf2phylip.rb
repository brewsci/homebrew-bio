class Vcf2phylip < Formula
  desc "Convert SNPs in VCF format to alignment file formats"
  homepage "https://github.com/edgardomortiz/vcf2phylip"
  url "https://github.com/edgardomortiz/vcf2phylip/archive/v2.0.tar.gz"
  sha256 "ec16affdc1e25314d02b6fe7330221b67b6ba0c02457649519f3f260cf796d9c"

  # migrating to py3: https://github.com/edgardomortiz/vcf2phylip/issues/16
  uses_from_macos "python@2"

  def install
    exe = "vcf2phylip.py"
    bin.install exe
  end

  test do
    # no way to get version: https://github.com/edgardomortiz/vcf2phylip/issues/22
    assert_match "nexus", shell_output("#{bin}/vcf2phylip.py -h 2>&1")
  end
end
