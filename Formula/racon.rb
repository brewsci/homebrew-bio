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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "bc9a20e8ac1a30b63b820ef024ec00aeaf13dc612121981ba9afb08ecba8161c"
    sha256 cellar: :any_skip_relocation, ventura:      "ea4352f961a0f338f34c480ce55b660a407a119a5751b3fd41711a736c1738f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff3e580c0e8789d9e3027d2545fe539ad067f713937094a7ebc6c849700204e0"
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
