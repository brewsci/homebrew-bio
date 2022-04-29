class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "96e89dcc7e54c7077726dbb6b932a0131b7b5d50b443cc70b24574f747380b2d"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2b9a78d4feac6b97d0f4de1be65de4695d07fb956ccb3f4374e30df7f5027f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffe5b0e038ac04f45c4a466cfaedcf85dd6d7e20486458d95631d8a766ec6bf7"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemmi --version")
    assert_match "Usage", shell_output("#{bin}/gemmi --help")
    assert_match "|||", shell_output("#{bin}/gemmi align --text-align MMCIF CIF -p")
  end
end
