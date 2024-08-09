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
    sha256 cellar: :any_skip_relocation, catalina:     "9a36412582dbf860ad19aa1d9795af7f6f6c326e4642fc0a8d6325431f363d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5925954884d8e3f99266f30a7d28dfc0113740fa5baca55ccc90d3c3683d73a"
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
    bin.install "build/bin/racon_test"
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
