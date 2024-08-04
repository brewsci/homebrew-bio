class Ntlink < Formula
  include Language::Python::Virtualenv

  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/archive/refs/tags/v1.3.10.tar.gz"
  sha256 "248ccae217dd7ed2e4664c6b48235f8db2ba24d8896b8315f6e657f19d5f7085"
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
  depends_on "python@3.12"
  depends_on "xz"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  resource "igraph" do
    url "https://files.pythonhosted.org/packages/5f/a0/1f70c34a96dcb0acf428319e83655e92ab2955d73a33f711852a5fb79681/igraph-0.11.6.tar.gz"
    sha256 "837f233256c3319f2a35a6a80d94eafe47b43791ef4c6f9e9871061341ac8e28"
  end

  def python3
    "python3.12"
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
