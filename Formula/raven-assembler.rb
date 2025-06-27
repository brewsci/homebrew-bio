class RavenAssembler < Formula
  desc "De novo DNA assembly of long uncorrected read"
  homepage "https://github.com/lbcb-sci/raven"
  url "https://github.com/lbcb-sci/raven/releases/download/0.0.0/raven-v0.0.0.tar.gz"
  sha256 "6ca62a0152e130216da2959099ca152aa21d6758770b74c430f515ff755c1b2d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "a2c5e6443f5f5199de1124cad4a2a6198cbb9501c2b4d5b26f1d84b6204e1e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "848aa58e9977cc568fb90aa73439e1b1706c165fc6e4a692b472c1ab3eee385b"
  end

  depends_on "cmake" => :build

  def install
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
