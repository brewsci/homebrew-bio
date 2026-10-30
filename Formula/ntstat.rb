class Ntstat < Formula
  desc "Compute k-mer statistics and Bloom filters from sequencing data"
  homepage "https://github.com/bcgsc/ntstat"
  url "https://github.com/bcgsc/ntstat/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "f5b365d4f8723ae108022fab7d7c67437aca70717ba81f4002eec13bab84c25a"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/ntstat.git", branch: "main"

  depends_on "argparse" => :build
  depends_on "cmake" => :build
  depends_on "indicators" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on "tabulate" => :build
  depends_on "btllib"
  depends_on "python@3.13"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Pin the build to python@3.13 so the compiled extension modules match the
    # interpreter that runs the installed launcher (python@3.13 only ships the
    # versioned python3.13 / python3.13-config programs).
    inreplace "meson.build" do |s|
      s.gsub! "find_installation('python3')", "find_installation('python3.13')"
      s.gsub! "find_program('python3-config')", "find_program('python3.13-config')"
    end

    # argparse, indicators and tabulate are header-only libraries. Homebrew ships
    # them with CMake configs only, and meson's dependency() lookup fails in the
    # build sandbox (the pkg-config shim is disabled and indicators' CMake config
    # errors out). Point the module builds at their headers directly instead.
    header_only = {
      "argparse"   => formula_opt_include("argparse"),
      "indicators" => formula_opt_include("indicators"),
      "tabulate"   => formula_opt_include("tabulate"),
    }
    inreplace Dir["src/modules/{filter,count}/meson.build"] do |s|
      header_only.each do |name, inc|
        s.gsub! "dependency('#{name}')", "declare_dependency(compile_args: ['-I#{inc}'])"
      end
    end

    # Disable LTO: it makes meson probe for llvm-ar (absent), and is unnecessary
    # for these Python extension modules.
    system "meson", "setup", "build", "--prefix", prefix, "-Db_lto=false"
    system "meson", "install", "-C", "build"

    # The launcher imports its bundled extension modules (ntstat.filter, ...),
    # so point it at the packaged site-packages and the pinned interpreter.
    site_packages = prefix/"lib/python3.13/site-packages"
    libexec.install bin/"ntstat"
    inreplace libexec/"ntstat", "#!/usr/bin/env python3",
              "#!#{formula_opt_bin("python@3.13")}/python3.13"
    (bin/"ntstat").write_env_script libexec/"ntstat", PYTHONPATH: site_packages
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ntstat --version")
    assert_match "filter", shell_output("#{bin}/ntstat filter --help")
  end
end
