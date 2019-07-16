class Iva < Formula
  # cite Hunt_2015: "https://doi.org/10.1093/bioinformatics/btv120"
  desc "Iterative Virus Assembler"
  homepage "https://github.com/sanger-pathogens/iva"
  url "https://github.com/sanger-pathogens/iva/archive/v1.0.9.tar.gz"
  sha256 "91ba402d0feacc88b3e34e71b4f10e0552702887e6e416076e57f95f6aaf7fad"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "49a1baf28d5f8e89175dc01f08e3e6a9b8439e493ade3f58a162cc9561b3ced1" => :sierra
    sha256 "eea163ae65cacbfca08005e99169d79ec7b641996b23751af0492176784576a6" => :x86_64_linux
  end

  depends_on "kmc"
  depends_on "mummer"
  depends_on "numpy"
  depends_on "python"
  depends_on "samtools"
  depends_on "smalt"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/21/89/ca320e5b45d381ae0df74c4b5694f1471c1b2453c5eb4bac3449f5970481/Cython-0.28.5.tar.gz"
    sha256 "b64575241f64f6ec005a4d4137339fb0ba5e156e826db2fdb5f458060d9979e0"
  end

  resource "decorator" do
    url "https://github.com/micheles/decorator/archive/4.3.1.tar.gz"
    sha256 "c1aab27d3f44ce8d3cb8c8c034180b2053d0cea4a011d2a58b9f85129bc3c7b0"
  end

  resource "networkx" do
    url "https://github.com/networkx/networkx/archive/networkx-2.1.tar.gz"
    sha256 "46aab610cdf15e680d944cafbf926a1d638f0cd2f1336b0f978b768a37d037f4"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/91/5e/cd2a8b4e3b601b89b9af2ecd706ffade96b6b2c89b2f8d50ab8a8bac3fed/pyfastaq-3.16.0.tar.gz"
    sha256 "368f3f1752668283f5d1aac4ea80e9595a57dc92a7d4925d723407f862af0e4e"
  end

  resource "pysam" do
    url "https://github.com/pysam-developers/pysam/archive/v0.15.0.1.tar.gz"
    sha256 "b169ffbe0efb39fd193779e5982da1de86e392dfe66c6bc49d79aa34fe58b46b"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    %w[cython pysam pyfastaq decorator networkx].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "usage", shell_output("#{bin}/iva 2>&1", 2)
    assert_match "-f reads_fwd -r reads_rev", shell_output("#{bin}/iva --help 2>&1")
  end
end
