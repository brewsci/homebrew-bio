class Pygobject3AT350 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://pygobject.gnome.org"
  url "https://download.gnome.org/sources/pygobject/3.50/pygobject-3.50.0.tar.xz"
  sha256 "8d836e75b5a881d457ee1622cae4a32bcdba28a0ba562193adb3bbb472472212"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "03514a10f4bdfc55dac46e6e19f4040692e5199f4ef4a341662ebe7b4f0375a6"
    sha256 cellar: :any, arm64_sequoia: "ad0b2afe8dfcff38b2686fa68822be6f75002c3db684be1ae4a89f5f113911bf"
    sha256 cellar: :any, arm64_sonoma:  "bb5c12a4181d6139da727a390f2c5bc8a77acaf066f711e4e322762fbc2ae4ae"
    sha256               x86_64_linux:  "ecae14b9407f28996a0bbac2a46cbf5cdeb1b73affc8a8bd08d6599181518374"
  end

  keg_only :versioned_formula

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

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
