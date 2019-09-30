class Nanofilt < Formula
  include Language::Python::Virtualenv

  # cite De_Coster_2018: "https://doi.org/10.1093/bioinformatics/bty149"
  desc "Filtering and trimming of long read sequencing data"
  homepage "https://github.com/wdecoster/nanofilt"
  url "https://github.com/wdecoster/nanofilt/archive/v2.5.0.tar.gz"
  sha256 "33c35aad2950145ef66bcf338e68c7c84a20ae62716db24f9c9ccbd881c9a277"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "164f29a1c55b1fc725bd10ad13cfb98add4e4083df4e9ef989288765fcb3a873" => :sierra
    sha256 "f6d9d7a62d2e3c1f0d3b7e03d7bb0c20444ad59f43f6269244c3b8114e879464" => :x86_64_linux
  end

  depends_on "python"

  resource "biopython" do
    url "https://files.pythonhosted.org/packages/8c/ce/380b3ad1d6653bb7b31b51bb3d4fbe9cced3180fe168acfd9f4e932ab12c/biopython-1.74.tar.gz"
    sha256 "25152c1be2c9205bf80901fc49adf2c2efff49f0dddbcf6e6b2ce31dfa6590c0"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/ac/36/325b27ef698684c38b1fe2e546e2e7ef9cecd7037bcdb35c87efec4356af/numpy-1.17.2.zip"
    sha256 "73615d3edc84dd7c4aeb212fa3748fb83217e00d201875a47327f55363cef2df"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/07/cf/1b6917426a9a16fd79d56385d0d907f344188558337d6b81196792f857e9/pandas-0.25.1.tar.gz"
    sha256 "cb2e197b7b0687becb026b84d3c242482f20cbb29a9981e43604eb67576da9f6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/27/c0/fbd352ca76050952a03db776d241959d5a2ee1abddfeb9e2a53fdb489be4/pytz-2019.2.tar.gz"
    sha256 "26c0b32e437e54a18161324a2fca3c4b9846b74a8dccddd843113109e1116b32"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/NanoFilt -v")
  end
end
