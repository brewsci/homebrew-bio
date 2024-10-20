class Ntlink < Formula
  include Language::Python::Virtualenv
  # cite Coombe_2021: "https://doi.org/10.1186/s12859-021-04451-7"
  desc "Assembly scaffolder using long reads and minimizers"
  homepage "https://bcgsc.ca/resources/software/ntlink"
  url "https://github.com/bcgsc/ntLink/archive/refs/tags/v1.3.11.tar.gz"
  sha256 "ca92bd4eb4cd6f2f81db54faaeaaf4686236f42db4b6f274f552a52a8460b869"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntLink.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "7a3807ba4bfc2ce2a0aaef49fc3534475569b678f3d0d0369630fb182690024b"
    sha256 cellar: :any,                 ventura:      "1dd519ac76ca9b037c462402f9014c31424c373fe66b2a3d4fefe13e35991ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8bf298669a7195526f3a36cb7ae6377e33447365ed72360490cbda826d968563"
  end

  depends_on "cmake" => :build
  depends_on "abyss"
  depends_on "brewsci/bio/btllib"
  depends_on "numpy"
  depends_on "python@3.13"
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
    "python3.13"
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
