class Peat < Formula
  # cite Li_2015: "https://doi.org/10.1186/1471-2105-16-S1-S2"
  desc "Paired-end trimmer with automatic adapter discovery"
  homepage "https://github.com/jhhung/PEAT"
  url "https://github.com/jhhung/PEAT/archive/v1.2.5.tar.gz"
  sha256 "5a44f888dcbae4b537141246a2e991249ae34930d553e1b0a10684309ac03e52"

  bottle do
    cellar :any
    sha256 "6de0b86edd00c6efee1c5f8d2b8370a6bbd46b30fc136d4bd1bfc6a1b2a5a10f" => :sierra
    sha256 "1aa583f4dbcf1ecd7a769a2d01a4403368b4e72528eb27f6ad8854e6e8674b37" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "../bin/PEAT"
    end
    pkgshare.install "test_file"
  end

  test do
    # Should return 0 not 1 | https://github.com/jhhung/PEAT/issues/37
    assert_match "single", shell_output("#{bin}/PEAT single --help 2>&1", 1)
    assert_match "paired", shell_output("#{bin}/PEAT paired --help 2>&1", 1)
  end
end
