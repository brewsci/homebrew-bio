class Raptor < Formula
  # cite Seiler_2021: "https://doi.org/10.1016/j.isci.2021.102782"
  # cite Mehringer_2023: "https://doi.org/10.1186/s13059-023-02971-4"
  desc "Pre-filter for querying very large collections of nucleotide sequences"
  homepage "https://github.com/seqan/raptor"
  url "https://github.com/seqan/raptor",
    using:    :git,
    tag:      "raptor-v3.0.1",
    revision: "01b8afc0ced404b036bece173f137f53a777ca51"
  license "BSD-3-Clause"
  head "https://github.com/seqan/raptor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 big_sur:      "b293099ca0f8d0d54dcf5ed8a2244cdcc6fb278d6c1cc6e647bc84271efa14fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8f6862223cf1a6b07ad08413d404eacda595f69c6580ac691969eb283f74e614"
  end

  depends_on "cmake" => :build
  depends_on "gcc@12"
  depends_on "yaml-cpp"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # The binary links libz, provided by zlib-ng-compat on Linux; declare it
  # directly so it is not flagged as an indirect-dependency linkage.
  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Requires gcc>=10, clang does not yet work.
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DRAPTOR_NATIVE_BUILD=OFF
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    # AVX2 is x86-only; build without it on arm64 (Apple Silicon).
    args << "-DCMAKE_CXX_FLAGS=-mavx2" if Hardware::CPU.intel?

    # The `layout` subcommand pulls in the bundled chopper/xxHash submodules via
    # FetchContent (local SOURCE_DIR) plus a nested ExternalProject. Homebrew's
    # FetchContent trap refuses even those local populations, and the bundled
    # CMakeLists predate CMake 4's policy floor; clear the trap and raise the
    # floor (also in the environment, so the nested ExternalProject cmake
    # invocations inherit it). This path is built on both Linux and macOS
    # (arm64), so apply it unconditionally.
    cmake_args = [".", *args, *std_cmake_args]
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    cmake_args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    # Must come after std_cmake_args to override Homebrew's trap injection.
    cmake_args << "-DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="

    system "cmake", *cmake_args
    system "make"
    bin.install "bin/raptor"
  end

  test do
    system "#{bin}/raptor", "--version"
    system "#{bin}/raptor", "build", "--help"
    system "#{bin}/raptor", "search", "--help"
  end
end
