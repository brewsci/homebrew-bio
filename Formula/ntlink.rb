class Ntlink < Formula
  include Language::Python::Shebang

  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/releases/download/v1.3.4/ntLink-1.3.4.tar.gz"
  sha256 "e36635639afafedc7b956ab4e5c8a4136b9516f781f44cac00b0ad96931fddc5"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "fb0bcfbd83bde98d3f5fb4f8f770694a8571dbba7f99c16fa40c7c3767400c09"
    sha256                               x86_64_linux: "e46685a82eba43812a8b6e79b175466f0da1dceea8d9eec7476ed3c92cfc766f"
  end

  depends_on "cmake" => :build
  depends_on "abyss"
  depends_on "btllib"
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "xz"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "python-igraph" do
    url "https://files.pythonhosted.org/packages/a3/74/dcd4c842370491f7db2c3152c6cc7febf296b01e8b2aedc45506f8486c04/igraph-0.10.1.tar.gz"
    sha256 "65165883cc506ec7c6d8b68e620954810935ef033138aa3a92cba6089339cae6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntLink help")
    assert_match "Usage", shell_output("#{bin}/ntLink_rounds help")
    assert_match "done", shell_output("#{bin}/ntLink check_install")
  end
end
