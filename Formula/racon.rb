class Racon < Formula
  # cite Vaser_2017: "https://doi.org/10.1101/gr.214270.116"
  include Language::Python::Shebang

  desc "Compute consensus sequence of a genome assembly of long uncorrected reads"
  homepage "https://github.com/lbcb-sci/racon"
  url "https://github.com/lbcb-sci/racon.git",
      tag:      "1.5.0",
      revision: "a2cfcac281d312a73912a97d6d960404f516c389"
  license "MIT"
  head "https://github.com/lbcb-sci/racon.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "fca478e2707bdac9196ace0a222e4a9ed81bac634ba9c52485be79a1ad0cd612"
    sha256 cellar: :any_skip_relocation, ventura:      "2af6f602b08f7029bab989e628077f8cc9b4625cf21e198d61423dd8c37c46d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f9b34aa3c123c08665b002f53fa2c9bd8e073460c6a68b42478101a39e4a486"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", ".", "-S", ".", "-B", "build", "-Dracon_build_wrapper=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    chmod 0755, Dir["scripts/*.py"]
    libexec.install Dir["scripts/*.py"]
    rewrite_shebang detected_python_shebang, *libexec.children
    bin.install_symlink libexec/"racon_preprocess.py" => "racon_preprocess"
    bin.install_symlink libexec/"racon_wrapper.py" => "racon_wrapper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/racon --version 2>&1")
    assert_match "usage", shell_output("#{bin}/racon --help")
  end
end
