class Vcf2phylip < Formula
  include Language::Python::Shebang

  desc "Convert SNPs in VCF format to alignment file formats"
  homepage "https://github.com/edgardomortiz/vcf2phylip"
  url "https://github.com/edgardomortiz/vcf2phylip/archive/v2.0.tar.gz"
  sha256 "ec16affdc1e25314d02b6fe7330221b67b6ba0c02457649519f3f260cf796d9c"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "834414b031110ed2d19b5152eb68395a3d7472016d9149c6629813a51bd4ce0b" => :catalina
    sha256 "70d43b99630cff5496f05307f90d8794c17757ab4eeecee51c81987759044746" => :x86_64_linux
  end

  depends_on "python"

  def install
    rewrite_shebang detected_python_shebang, "vcf2phylip.py"
    bin.install "vcf2phylip.py"
    bin.install_symlink "vcf2phylip.py" => "vcf2phylip"
  end

  test do
    assert_match "usage", shell_output("#{bin}/vcf2phylip.py -h 2>&1")
  end
end
