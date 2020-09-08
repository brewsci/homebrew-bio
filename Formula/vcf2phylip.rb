class Vcf2phylip < Formula
  include Language::Python::Shebang

  desc "Convert SNPs in VCF format to alignment file formats"
  homepage "https://github.com/edgardomortiz/vcf2phylip"
<<<<<<< HEAD
  url "https://github.com/edgardomortiz/vcf2phylip/archive/v2.0.tar.gz"
  sha256 "ec16affdc1e25314d02b6fe7330221b67b6ba0c02457649519f3f260cf796d9c"
  revision 1
=======
  url "https://github.com/edgardomortiz/vcf2phylip/archive/v2.3.tar.gz"
  sha256 "fe72002a85d886df6527678c3c9f4610d1535d26c02ea0df133d10ad18e26272"
  license "GPL-3.0"
>>>>>>> upstream/develop

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
<<<<<<< HEAD
    sha256 "21244da7b9ea1b90afd4096164bfc7cfcedb6953b5368f17e9dc1754dca5764b" => :catalina
    sha256 "910ce0bc45540b67fedb89fc462238abe0b2daf4f803f7a83945b39f4faf613d" => :x86_64_linux
  end

  depends_on "python"
=======
    sha256 "4bf14803c03c07a2bba536d4ea6d81ede6c074d4ba7bd5574626d4902647b0c4" => :catalina
    sha256 "6f6121e02dfffdc964828c07f30ec6f601a3614234c3f4b69a9c2480b77d4992" => :x86_64_linux
  end

  depends_on "python@3.8"
>>>>>>> upstream/develop

  def install
    rewrite_shebang detected_python_shebang, "vcf2phylip.py"
    bin.install "vcf2phylip.py"
    bin.install_symlink "vcf2phylip.py" => "vcf2phylip"
  end

  test do
    assert_match "usage", shell_output("#{bin}/vcf2phylip.py -h 2>&1")
  end
end
