class RavenAssembler < Formula
  desc "De novo DNA assembly of long uncorrected read"
  homepage "https://github.com/lbcb-sci/raven"
  url "https://github.com/lbcb-sci/raven/archive/refs/tags/1.8.3.tar.gz"
  sha256 "5e7725d1115f7bbd2b6e72d3eb813e99beee552abdb751050d092de2348e5439"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "a2c5e6443f5f5199de1124cad4a2a6198cbb9501c2b4d5b26f1d84b6204e1e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "848aa58e9977cc568fb90aa73439e1b1706c165fc6e4a692b472c1ab3eee385b"
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
      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/raven --version 2>&1")
  end
end
