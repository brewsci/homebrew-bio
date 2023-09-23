class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/v0.6.3.tar.gz"
  sha256 "d7fa5e2a96f2093900a8ceaf835d2761562b5c42403e3f4cc98d32bb94f6a091"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, monterey:     "ee8f87298372cd3da626ee8d1651da7352dce5ebf1ebe6544ab72130a23e1400"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99ae3f72f141cbe0d3ffbdb3d10110c9ded922c32ce5051af91efb4364520201"
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
