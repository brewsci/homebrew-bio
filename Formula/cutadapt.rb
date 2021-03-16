class Cutadapt < Formula
  include Language::Python::Virtualenv
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
    tag:      "v3.3",
    revision: "27a6817a842c29f4108e1e96cc93c83d694fcdff"
  license "MIT"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "5f6a49a7ff02dd80c1945a436a85ad82bfc94983726bfc38fa22f5cf7ef39d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58bc4e0007eafa31bb2d8928f17a7616fca976e0c1e2dfaf5043ab9d491194f0"
  end

  depends_on "python@3.9"

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/75/32/710e24c5bb31ad680969a042428dedfa5741aee987afc2c7d177d3e4928f/dnaio-0.5.0.tar.gz"
    sha256 "6d01979159057954a265d81767f8cb26721a6d3a458601a73d1647792a50134c"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/67/53/404e1039117edc500f32ba6104e2d580e06adf803a9553841fe61f5b110e/xopen-1.1.0.tar.gz"
    sha256 "38277eb96313b2e8822e19e793791801a1f41bf13ee5b48616a97afc65e9adb3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "interleaved", shell_output("#{bin}/cutadapt -h 2>&1")
  end
end
