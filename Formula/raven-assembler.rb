class RavenAssembler < Formula
  desc "De novo DNA assembly of long uncorrected read"
  homepage "https://github.com/lbcb-sci/raven"
  url "https://github.com/lbcb-sci/raven/releases/download/0.0.0/raven-v0.0.0.tar.gz"
  sha256 "6ca62a0152e130216da2959099ca152aa21d6758770b74c430f515ff755c1b2d"

  depends_on "cmake" => :build

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/raven --version 2>&1")
  end
end
