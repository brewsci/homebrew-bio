class Gemmi < Formula
  # cite Wojdyr_2022: "https://doi.org/10.21105/joss.04200"
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "9e2a8a51e62c69bf43f62aadf527ca4312860de8a36c12a8747d3e8ae556f0b3"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_tahoe:   "6c40294a9da2652e886d09fddd323802b7215ae483e9474bd0835c03aaa581ee"
    sha256 cellar: :any,                 arm64_sequoia: "32c46cb9f6a2148791ad169efa94e23a614d2c13ae712fcb5ac3bff082a6af15"
    sha256 cellar: :any,                 arm64_sonoma:  "e987a398c7bb1afbde2de9628ada4fce7f26eb470f7defcfc6c1860c807e66b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b281a0a841dd232f3ad873dd2d3f4c715c679686d3a0dfe9d02a97fd34f08b"
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
