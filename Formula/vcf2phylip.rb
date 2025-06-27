class Vcf2phylip < Formula
  include Language::Python::Shebang

  desc "Convert SNPs in VCF format to alignment file formats"
  homepage "https://github.com/edgardomortiz/vcf2phylip"
  url "https://github.com/edgardomortiz/vcf2phylip/archive/v2.3.tar.gz"
  sha256 "fe72002a85d886df6527678c3c9f4610d1535d26c02ea0df133d10ad18e26272"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "4bf14803c03c07a2bba536d4ea6d81ede6c074d4ba7bd5574626d4902647b0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f6121e02dfffdc964828c07f30ec6f601a3614234c3f4b69a9c2480b77d4992"
  end

  depends_on "python@3.8"

  def install
    rewrite_shebang detected_python_shebang, "vcf2phylip.py"
    bin.install "vcf2phylip.py"
    bin.install_symlink "vcf2phylip.py" => "vcf2phylip"
  end

  test do
    assert_match "usage", shell_output("#{bin}/vcf2phylip.py -h 2>&1")
  end
end
