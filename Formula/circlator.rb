class Circlator < Formula
  # cite Hunt_2015: "https://doi.org/10.1186/s13059-015-0849-0"

  include Language::Python::Virtualenv

  desc "Tool to circularize genome assemblies"
  homepage "https://sanger-pathogens.github.io/circlator/"
  url "https://github.com/sanger-pathogens/circlator/archive/v1.5.5.tar.gz"
  sha256 "927b6c156bfba6fa02db0c1173e280f85373320814c51e084170df583e604a2a"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "3768e23648fdacd33e43f562dcaf6a7cbe20006e3f4a2c03f5f3c62e400fd216" => :sierra
    sha256 "310c5d97d4320ffbde5f0aedbcc7e05d03b721452714cf0e5dd21e5f3e1767f0" => :x86_64_linux
  end

  depends_on "bwa"
  depends_on "mummer"
  depends_on "prodigal"
  depends_on "python"
  depends_on "samtools"
  depends_on "spades"
  depends_on "zlib" unless OS.mac?

  resource "cython" do
    url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
    sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
  end

  resource "et_xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/8c/75/c4e557207c7ff3d217d002d4fee32b4e5dbfc5498e2a2c9ce6b5424c5e37/openpyxl-2.4.9.tar.gz"
    sha256 "95e007f4d121f4fd73f39a6d74a883c75e9fa9d96de91d43c1641c103c3a9b18"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/91/5e/cd2a8b4e3b601b89b9af2ecd706ffade96b6b2c89b2f8d50ab8a8bac3fed/pyfastaq-3.16.0.tar.gz"
    sha256 "368f3f1752668283f5d1aac4ea80e9595a57dc92a7d4925d723407f862af0e4e"
  end

  resource "pymummer" do
    url "https://files.pythonhosted.org/packages/79/4c/15ef3401217379fcc53e33e67a9aa1b89449825d7246fa527879892b5305/pymummer-0.10.3.tar.gz"
    sha256 "986555d36828bd90bf0e63d9d472e5b20c191f0e51123b5252fa924761149fc2"
  end

  resource "pysam" do
    url "https://github.com/pysam-developers/pysam/archive/v0.15.0.1.tar.gz"
    sha256 "b169ffbe0efb39fd193779e5982da1de86e392dfe66c6bc49d79aa34fe58b46b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    output = shell_output("#{bin}/circlator test outdir")
    assert_match "Finished run on test data OK", output
  end
end
