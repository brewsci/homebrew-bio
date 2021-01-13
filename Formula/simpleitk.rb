class Simpleitk < Formula
  desc "Simplified layer built on top of ITK"
  homepage "https://simpleitk.org/"
  url "https://github.com/SimpleITK/SimpleITK/releases/download/v2.0.2/SimpleITK-2.0.2.tar.gz"
  sha256 "56117842e0be53a4a7f482d9da2b62f56a85a6ea89b33389a7d6655fb8d3a200"
  head "https://github.com/SimpleITK/SimpleITK.git"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    # Superbuild does only work in an out-of-source build, create a new folder
    mkdir "../SimpleITK-build" do
      system "cmake", "../SimpleITK-2.0.2/SuperBuild"
    end
  end

  test do
    system "ctest", "."
  end
end
