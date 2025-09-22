class Gemmi < Formula
  # cite Wojdyr_2022: "https://doi.org/10.21105/joss.04200"
  desc "Macromolecular crystallography library and utilities"
  homepage "https://project-gemmi.github.io/"
  url "https://github.com/project-gemmi/gemmi/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ed5e1d0665f27d623d877fa36f6c99a5de21310cc8715337ff9f6b545bd2e9d3"
  license "MPL-2.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "d54ea495a7d091ab43fd7e0b1c9a549b68eac4a82269f175804bad90780c7ca3"
    sha256 cellar: :any,                 arm64_sequoia: "bae6cb5a27c35a22cf09236e44187884d901918206f68e67544320b76cd16ba2"
    sha256 cellar: :any,                 arm64_sonoma:  "39cba9c5de6c3f94d9479c781fae4d8cbbb00194b85d5852405190f1d9437c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e543074581eef058f2870ae3ba22f1193bfc4b326fb0ceacd794dbcad834f509"
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
