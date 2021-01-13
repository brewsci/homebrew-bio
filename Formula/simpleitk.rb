class Simpleitk < Formula
  desc "Simplified layer built on top of ITK"
  homepage "https://simpleitk.org/"
  url "https://github.com/SimpleITK/SimpleITK/releases/download/v2.0.2/SimpleITK-2.0.2.tar.gz"
  sha256 "3ecb05be010898799c1af18f2cf385c639a1fd99a453d9a4ed2eded52b4821a1"
  head "https://github.com/SimpleITK/SimpleITK.git"

  depends_on "cmake" => :build

  def install
    # Superbuild does only work in an out-of-source build, create a new folder
    mkdir "SimpleITK-build" do
      system "cmake", "../SuperBuild/"
    end
  end

  test do
    system "ctest", "."
  end
end
