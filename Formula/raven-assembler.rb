class RavenAssembler < Formula
  desc "De novo DNA assembly of long uncorrected read"
  homepage "https://github.com/lbcb-sci/raven"
  url "https://github.com/lbcb-sci/raven/archive/refs/tags/1.8.3.tar.gz"
  sha256 "5e7725d1115f7bbd2b6e72d3eb813e99beee552abdb751050d092de2348e5439"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86b200972144ef249645fdb53b20875da2e0b7cd328f71edd18da8c194b92e62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20653812b4be84396ba30805921e79ee1011bbeae48f0a7434412dd81ac617e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6343f43ce0e8f44192bbabd47b44b323c40913b80c64a91cdbcf2898a2f0247"
    sha256 cellar: :any,                 x86_64_linux:  "1469e8fd454fe95ee94b365597ee136769a6bfb512b0c5c5877d60cb201e6174"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  # The raven binary links libz (via bioparser/racon); on Linux use the brewed
  # zlib-ng-compat so linkage isn't flagged against the host system libz.
  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # cereal (fetched via FetchContent) still declares cmake_minimum_required < 3.5
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    args = ["-DRAVEN_BUILD_EXE=ON"]
    args << "-DZLIB_ROOT=#{formula_opt_prefix("zlib-ng-compat")}" if OS.linux?
    mkdir "build" do
      system "cmake", "-S", "..", "-B", ".", *args, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/raven --version 2>&1")
  end
end
