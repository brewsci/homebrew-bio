class Pygobject3AT350 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.50/pygobject-3.50.0.tar.xz"
  sha256 "8d836e75b5a881d457ee1622cae4a32bcdba28a0ba562193adb3bbb472472212"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "1fb0df5ae11106e824aadafb93fc3be7628fe2d5c21984522ce59b23e74d81d7"
    sha256 cellar: :any, arm64_sequoia: "9b5e53e77fea99cfb9531d1529566d5832b5048a50bbff5f962f193fd323eca6"
    sha256 cellar: :any, arm64_sonoma:  "eb45923e424a62b94b08dba614a9603347a896b672f630a643bdd6b79488410d"
    sha256               x86_64_linux:  "ae6fe871356aad5ffd6f8a19515313f757c07a85ba6faf96ab77217994ca0d81"
  end

  keg_only :versioned_formula

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "py3cairo"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    pythons.each do |python|
      xy = Language::Python.major_minor_version(python)
      builddir = "buildpy#{xy}".delete(".")

      system "meson", "setup", builddir, "-Dpycairo=enabled",
                                         "-Dpython=#{python}",
                                         "-Dpython.platlibdir=#{site_packages(python)}",
                                         "-Dpython.purelibdir=#{site_packages(python)}",
                                         "-Dtests=false",
                                         *std_meson_args
      system "meson", "compile", "-C", builddir, "--verbose"
      system "meson", "install", "-C", builddir
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pythons.each do |python|
      ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system python, "test.py"
    end
  end
end
