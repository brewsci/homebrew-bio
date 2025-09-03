class Gemmi < Formula
  # cite Wojdyr_2022: "https://doi.org/10.21105/joss.04200"
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ed5e1d0665f27d623d877fa36f6c99a5de21310cc8715337ff9f6b545bd2e9d3"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "479ef836d8ab2cb2c329caace6cf6ef8c2a5cf37a2f402a422ee6a91c1b3fc29"
    sha256 cellar: :any,                 arm64_sonoma:  "5c0f6eea0e9d117263214d296ac244a7557415bda142200c10187939ef739e4b"
    sha256 cellar: :any,                 ventura:       "5a1a37d9eb856694ce2b38ed621d3c95f2020413aea22d70741e29047cb05a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44044851e8c5d402622d65eed181acdbadb5b78f186bfbc15576a5f4104809af"
  end

  depends_on "cmake" => :build
  depends_on "nanobind" => :build
  depends_on "ninja" => :build
  depends_on "robin-map" => :build
  depends_on "python@3.13"
  depends_on "zlib-ng" # Faster than zlib

  def install
    py_ver = Language::Python.major_minor_version "python3"
    site_packages = lib/"python#{py_ver}/site-packages"
    mkdir_p site_packages

    ENV.append "CPPFLAGS", "-I#{Formula["nanobind"].opt_lib/"python#{py_ver}/site-packages/nanobind/include"}"
    ENV.append "CPPFLAGS", "-I#{Formula["python@3.13"].opt_include}/python#{py_ver}"

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
