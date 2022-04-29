class Gemmi < Formula
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "96e89dcc7e54c7077726dbb6b932a0131b7b5d50b443cc70b24574f747380b2d"
  license "MPL-2.0"
  head "https://github.com/project-gemmi/gemmi.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "0d61b3b9d065e2aa1cc404f0656ecad79db74970b4d1ca937c2842fcf5b1e024"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e12d0fc99ceabf787593b472d94cd5bc791f22818aefe9784e17669e483839f2"
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
