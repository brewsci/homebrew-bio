class Peat < Formula
  # cite Li_2015: "https://doi.org/10.1186/1471-2105-16-S1-S2"
  desc "Paired-end trimmer with automatic adapter discovery"
  homepage "https://github.com/jhhung/PEAT"
  url "https://github.com/jhhung/PEAT/archive/v1.2.4.tar.gz"
  sha256 "1e1c0e7dfd108f10e1ed7a139a1f08e4b30edf7ad47dff28705f351935fa5ecf"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "curl"
  depends_on "zlib" unless OS.mac?

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version 2>&1")
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
