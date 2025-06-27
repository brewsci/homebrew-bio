class SdslLite < Formula
  # cite Gog_2013: "https://arxiv.org/abs/1311.1249"
  desc "Succinct Data Structure Library 2.0"
  homepage "https://github.com/simongog/sdsl-lite"

  # Use git to get submodules.
  url "https://github.com/simongog/sdsl-lite.git",
    revision: "0546faf0552142f06ff4b201b671a5769dd007ad",
    tag:      "v2.1.1"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "e44e437f1f32ce5fb6de0cfc5aec132bfc09322ad71c211a8bb77bc332d4325c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "34182f95fd635533ba8f686b5ebafe411204dbcb3969a6b2e92f2e22c4d778bb"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "./install.sh", prefix
    pkgshare.install "examples", "extras", "tutorial"
  end

  test do
    ENV.cxx11
    system(*ENV.cxx.split, "-o", "fm-index",
      "-I#{opt_include}", pkgshare/"examples/fm-index.cpp",
      "-L#{opt_lib}", "-lsdsl", "-ldivsufsort", "-ldivsufsort64")
    assert_match "FM-index", shell_output("./fm-index 2>&1", 1)
  end
end
