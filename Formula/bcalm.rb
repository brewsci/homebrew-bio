class Bcalm < Formula
  # cite Chikhi_2016: "https://doi.org/10.1093/bioinformatics/btw279"
  desc "De Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  url "https://github.com/GATB/bcalm.git",
      tag:      "v2.2.3",
      revision: "1f8a8b15e84f6bcaf47296eb3eb381288131b203"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "dcc1e682e002280de1aab1401b61c6c74921ea92e9e855325546c06e5da4c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d9e93a21a9cddaf7647a8947539d6ebbfa93c904bba36498bb9f0bf1ccdcbd28"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    # bcalm and its gatb-core submodule request an ancient CMake policy version
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      if OS.linux?
        # gatb-core bakes CMAKE_C_COMPILER (Homebrew's shim wrapper on Linux)
        # into bin/bcalm via a generated build_info.hpp, which trips brew
        # audit's check for references to the Homebrew shims directory.
        inreplace "ext/gatb-core/include/gatb/system/api/build_info.hpp",
                  HOMEBREW_SHIMS_PATH.to_s, "/usr/bin"
      end
      system "make"
      bin.install "bcalm"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/bcalm")
  end
end
