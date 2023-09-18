class Ntlink < Formula
  include Language::Python::Virtualenv

  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "3a6fe7ca9c7a0226cf51b7e55804e235ac2b959e82a30f9bce55b9caea5bb03b"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 monterey:     "174b8d115b21054c2339615fe83dfc85f36942189aebe765f6b9df6490a13133"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1c2cb1bf98e99920151560ccad880d38193f6717978861dd3c79673c4be67456"
  end

  depends_on "cmake" => :build
  depends_on "abyss"
  depends_on "btllib"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "xz"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  resource "igraph" do
    url "https://files.pythonhosted.org/packages/a3/74/dcd4c842370491f7db2c3152c6cc7febf296b01e8b2aedc45506f8486c04/igraph-0.10.1.tar.gz"
    sha256 "65165883cc506ec7c6d8b68e620954810935ef033138aa3a92cba6089339cae6"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath
    (libexec/"bin").install %w[ntLink ntLink_rounds]
    %w[ntLink ntLink_rounds].each do |f|
      (bin/f).write_env_script libexec/"bin"/f, PYTHONPATH: libexec/"lib"/python3/"site-packages"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntLink help")
    assert_match "Usage", shell_output("#{bin}/ntLink_rounds help")
    assert_match "done", shell_output("#{bin}/ntLink check_install")
  end
end
