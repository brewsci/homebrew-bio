class Cutadapt < Formula
  # cite Martin_2011: "https://doi.org/10.14806/ej.17.1.200"
  include Language::Python::Virtualenv
  desc "Removes adapter sequences, primers, and poly-A tails"
  homepage "https://github.com/marcelm/cutadapt"
  url "https://github.com/marcelm/cutadapt.git",
    tag:      "v4.9",
    revision: "9276a89d5df9282ff51602b042b40c3b48c98566"
  license "MIT"
  head "https://github.com/marcelm/cutadapt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "dab2c1902b604737600c91677011316c14e0b853fa5c41359b64e35a684a81b3"
    sha256 cellar: :any_skip_relocation, ventura:      "472aeab251d5bd2f291fa38207eb73cfa6829abb235e21fdc5cd6a8892d0cbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4fa6304e5243642aa00ad573ff7b6cd42baaa9a781ea4d74bac9675a8c502946"
  end

  depends_on "cython" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@3.12"

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/2b/bf/c62568ad2e5be8eb9760ddf3ab66107a4ef2a47fe1bb92de5eb5322e65d8/dnaio-1.2.1.tar.gz"
    sha256 "4786dc63614b9f3011463d9ea9d981723dd38d1091a415a557f71d8c74400f38"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/47/01/0abf3e42bb1bf15ce24e4b235b1274e0c3c9ba8e3bbf2300b6323e6f50c1/xopen-2.0.2.tar.gz"
    sha256 "f19d83de470f5a81725df0140180ec71d198311a1d7dad48f5467b4ad5df6154"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.fastq").write <<~EOS
      @U00096.2:1-70
      ATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGCAACCGGTT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII00000000
    EOS
    shell_output("#{bin}/cutadapt -a AACCGGTT -o output.fastq test.fastq 2>&1")
    assert_match "AGCAGC\n+", File.read("output.fastq")
  end
end
