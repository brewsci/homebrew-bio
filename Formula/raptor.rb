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
    sha256 cellar: :any, arm64_tahoe:   "122c3302e9b4b0302db23047aa06fae83472882cc9721881386ed900a02793c1"
    sha256 cellar: :any, arm64_sequoia: "d009510d7f33546181b491ed2e91cc40a6fb9ff06b7ca4656038a4fe862ab863"
    sha256 cellar: :any, arm64_sonoma:  "71b32bdcfc3ee14d267f182425d6f2ca5862594cc985afae45a16d32d85861e9"
    sha256 cellar: :any, x86_64_linux:  "b7df4be9087f8670606adbead41b4b324be6b422906bbda391daa7d9fc82b22f"
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    # gcc@12's bundled <arm_acle.h> is broken on arm64 macOS (Tahoe), and the
    # newest brewed gcc mis-emits duplicate template symbols this SeqAn version
    # trips over; compile with gcc@14. Runtime libstdc++/libgomp come from the
    # current "gcc" (forward-compatible), which is what the binary links.
    depends_on "gcc@14" => :build
    depends_on "gcc" # runtime
  end

  on_linux do
    depends_on "gcc@12"
    # Everything is built with gcc/libstdc++ here, so the brewed yaml-cpp is
    # ABI-compatible and used directly.
    depends_on "yaml-cpp"
    # The binary links libz, provided by zlib-ng-compat on Linux; declare it
    # directly so it is not flagged as an indirect-dependency linkage.
    depends_on "zlib-ng-compat"
  end

  # Requires gcc>=10, clang does not yet work.
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"

  # Used on macOS only (see install): the brewed yaml-cpp is compiled with
  # clang/libc++, whose C++ ABI is incompatible with this formula's
  # gcc/libstdc++ build (the chopper/sharg stack fails to link YAML symbols), so
  # build a matching gcc copy from source. Keep in sync with the brewed yaml-cpp.
  resource "yaml-cpp" do
    url "https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.9.0.tar.gz"
    sha256 "25cb043240f828a8c51beb830569634bc7ac603978e0f69d6b63558dadefd49a"
  end

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DRAPTOR_NATIVE_BUILD=OFF
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
    ]
    # AVX2 is x86-only; build without it on arm64 (Apple Silicon).
    args << "-DCMAKE_CXX_FLAGS=-mavx2" if Hardware::CPU.intel?

    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    if OS.mac?
      # Pin the compiler to gcc@14 (see the dependency note above).
      gcc = Formula["gcc@14"]
      ENV["CC"] = gcc.opt_bin/"gcc-14"
      ENV["CXX"] = gcc.opt_bin/"g++-14"
      args << "-DCMAKE_C_COMPILER=#{gcc.opt_bin}/gcc-14"
      args << "-DCMAKE_CXX_COMPILER=#{gcc.opt_bin}/g++-14"

      # Build yaml-cpp from source with the same gcc so its libstdc++ ABI
      # matches, then let find_package pick it up (FetchContent prefers
      # find_package via the flag above).
      resource("yaml-cpp").stage do
        yaml_prefix = buildpath/"yaml-cpp"
        system "cmake", "-S", ".", "-B", "build",
               "-DYAML_CPP_BUILD_TESTS=OFF",
               "-DYAML_BUILD_SHARED_LIBS=OFF",
               "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
               "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
               *std_cmake_args(install_prefix: yaml_prefix)
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
        ENV.prepend_path "CMAKE_PREFIX_PATH", yaml_prefix
      end
    end

    # The `layout` subcommand pulls in the bundled chopper/xxHash submodules via
    # FetchContent (local SOURCE_DIR) plus a nested ExternalProject. Homebrew's
    # FetchContent trap refuses even those local populations, and the bundled
    # CMakeLists predate CMake 4's policy floor; clear the trap and raise the
    # floor (also in the environment, so the nested ExternalProject cmake
    # invocations inherit it).
    cmake_args = [".", *args, *std_cmake_args]
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
