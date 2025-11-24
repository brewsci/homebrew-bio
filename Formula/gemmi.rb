class Gemmi < Formula
  # cite Wojdyr_2022: "https://doi.org/10.21105/joss.04200"
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "58ed9023e0f75033ebec1da630461bc6e1af661f29f0c41deed66c20315ebe2a"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "cafb71e3534243b33bd1f8ce42baf0df5809833e20a10320e9c7ac41ab9fed93"
    sha256 cellar: :any,                 arm64_sequoia: "8dc6d7669a5ba54a0564942a8c0476bfdb740767922275f8256cf8aa2f1f759f"
    sha256 cellar: :any,                 arm64_sonoma:  "b9a14602fc2932e4a4fcdd3465b53e555ef3ab419f19db7bd72b4ead4222c697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba8433f83975d5c4e1705db56adbecbe7f5e2ec17d7af7b101981e15debc735"
  end

  depends_on "cmake" => :build
  depends_on "nanobind" => :build
  depends_on "ninja" => :build
  depends_on "robin-map" => :build
  depends_on "python@3.14"
  depends_on "zlib-ng" # Faster than zlib

  def install
    py_ver = Language::Python.major_minor_version "python3"
    site_packages = lib/"python#{py_ver}/site-packages"
    mkdir_p site_packages

    ENV.append "CPPFLAGS", "-I#{Formula["nanobind"].opt_lib/"python#{py_ver}/site-packages/nanobind/include"}"
    ENV.append "CPPFLAGS", "-I#{Formula["python@3.14"].opt_include}/python#{py_ver}"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
      "-DCMAKE_CXX_FLAGS=#{ENV["CXXFLAGS"]} #{ENV["CPPFLAGS"]}",
      "-DUSE_PYTHON=ON",
      "-DPYTHON_INSTALL_DIR=#{site_packages}",
      "-DUSE_ZLIB_NG=ON",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/project-gemmi/gemmi/master/tests/5i55.cif"
      sha256 "cae937745acc22d1c3bdd21cc6fa3c36a3d9f271494c22e3e3a3ce512c72fb1d"
    end
    resource("homebrew-testdata").stage testpath/"example"
    assert_match "_atom_site.B_iso_or_equiv\t1\t218", shell_output("#{bin}/gemmi tags example/5i55.cif")

    # Check if the Python module can be imported
    system "python3", "-c", "import gemmi"
  end
end
