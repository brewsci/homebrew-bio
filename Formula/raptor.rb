class Raptor < Formula
  # cite Seiler_2021: "https://doi.org/10.1016/j.isci.2021.102782"
  # cite Mehringer_2023: "https://doi.org/10.1186/s13059-023-02971-4"
  desc "Pre-filter for querying very large collections of nucleotide sequences"
  homepage "https://github.com/seqan/raptor"
  url "https://github.com/seqan/raptor",
    using:    :git,
    tag:      "raptor-v3.0.1",
    revision: "387c7da78f2ebdd72feddabc1e4dddcbe026b4ad"
  license "BSD-3-Clause"
  head "https://github.com/seqan/raptor.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 big_sur:      "b293099ca0f8d0d54dcf5ed8a2244cdcc6fb278d6c1cc6e647bc84271efa14fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8f6862223cf1a6b07ad08413d404eacda595f69c6580ac691969eb283f74e614"
  end

  depends_on "cmake" => :build
  depends_on "gcc@12"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    ]
    # AVX2 is x86-only; build without it on arm64 (Apple Silicon).
    args << "-DCMAKE_CXX_FLAGS=-mavx2" if Hardware::CPU.intel?

    system "cmake", ".", *args, *std_cmake_args
    system "make"
    bin.install "bin/raptor"
  end

  test do
    system "#{bin}/raptor", "--version"
    system "#{bin}/raptor", "build", "--help"
    system "#{bin}/raptor", "search", "--help"
  end
end
