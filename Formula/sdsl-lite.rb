class SdslLite < Formula
  # cite Gog_2013: "https://arxiv.org/abs/1311.1249"
  desc "Succinct Data Structure Library 2.0"
  homepage "https://github.com/simongog/sdsl-lite"

  # use git to get submodules
  # url "https://github.com/simongog/sdsl-lite/archive/v2.1.1.tar.gz"
  # sha256 "e36591338c390184760dbdddbb653d972d9c1986c8819f462e7e73ddd28b992b"
  url "https://github.com/simongog/sdsl-lite.git",
    :revision => "0546faf0552142f06ff4b201b671a5769dd007ad",
    :tag => "v2.1.1"
  revision 3

  depends_on "cmake" => :build

  # this library is now part of SDSL - should remove the formula?
  conflicts_with "libdivsufsort"

  needs :cxx11

  def install
    ENV.cxx11
    system "./install.sh", prefix
    pkgshare.install "examples", "extras", "tutorial"
  end

  test do
    ENV.cxx11
    exe = "fm-index"
    system *ENV.cxx.split, "-o", exe,
      "-I#{opt_include}", pkgshare/"examples/fm-index.cpp",
      "-L#{opt_lib}", "-lsdsl", "-ldivsufsort", "-ldivsufsort64"
    assert_match "FM-index", shell_output("./#{exe} 2>&1", 1)
  end
end
