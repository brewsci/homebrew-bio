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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "a7e1b9074198a4c11332be5d7401d3947f94609a34e9776bb985235c681890db"
    sha256 cellar: :any,                 ventura:      "3a4ddadc1b5fd9fea5b87b280f61a917b458556de6d29fa07c5aad881df43d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d63aa35822caeda13a504976352665beae29041a764890caf12e6a2519093c15"
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
