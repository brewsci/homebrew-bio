class Coot < Formula
  desc "Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://github.com/pemsley/coot/archive/refs/tags/Release-1.1.20.tar.gz"
  sha256 "3bac75e3aaa7991ff2c24539cc594f1e1c205fe1bd7aa256e4f4d13120fdd04f"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]
  head "https://github.com/pemsley/coot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "5a0a765feb0a859d2114ca798aee086c2f3df10e0865e65bcacb5c52b6988945"
    sha256 arm64_sequoia: "7ade32725c80627bfc4591a8233e7277a4052570eb9d0d4b75629e513d35a48c"
    sha256 arm64_sonoma:  "49fbdcf0825cf6e1433ca95945c5f08752d094fb149e6e894accf2fda6fcbe87"
    sha256 x86_64_linux:  "ab65a8dcdd1e811ce0f99d9349d33a663197d2b735a6b1ca93beee787cdcf54f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clipper4coot"
  depends_on "brewsci/bio/gemmi"
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"
  depends_on "brewsci/bio/raster3d"
  depends_on "brewsci/bio/ssm"
  depends_on "cairo"
  depends_on "coordgen"
  depends_on "dwarfutils"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmp"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libepoxy"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"
  depends_on "numpy"
  depends_on "openal-soft"
  depends_on "openblas"
  depends_on "pango"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.14"
  depends_on "rdkit"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  resource "monomers" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/refmac-monomer-library.tar.gz"
    sha256 "03562eec612103a48bd114cfe0d171943e88f94b84610d16d542cda138e5f36b"
  end

  resource "reference-structures" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/reference-structures.tar.gz"
    sha256 "44db38506f0f90c097d4855ad81a82a36b49cd1e3ffe7d6ee4728b15109e281a"
  end

  patch :DATA

  def python3
    "python3.14"
  end

  def install
    # fix issue of https://github.com/pemsley/coot/issues/266
    # include <iomanip> is needed for std::setw on Linux
    inreplace "src/molecule-class-info.h",
              "#include \"compat/coot-sysdep.h\"",
              "#include \"compat/coot-sysdep.h\"\n#include <iomanip>\n#include <cmath>"
    # fix error of molecule-class-info-backup.cc:104:70:
    # error: 'fabsf' is not a member of 'std'; did you mean 'fabs'?
    inreplace "src/molecule-class-info-backup.cc",
              "#include <utility>",
              "#include <utility>\n#include <cmath>"
    inreplace "src/molecule-class-info-backup.cc",
              "fabsf",
              "fabs"
    ENV.cxx11
    ENV.libcxx
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    if OS.mac?
      inreplace "./configure", "$wl-flat_namespace", ""
      inreplace "./configure", "$wl-undefined ${wl}suppress", "-undefined dynamic_lookup"
    end

    # Get Python location
    xy = Language::Python.major_minor_version python3
    (lib/"python#{xy}/site-packages/homebrew-coot.pth").write "#{libexec/"lib/python#{xy}/site-packages"}\n"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    # # Tweak to include pygobject3@3.50
    # ENV.prepend_path "PYTHONPATH",
    #                  Formula["brewsci/bio/pygobject3@3.50"].opt_prefix/Language::Python.site_packages(python3)
    # ENV.prepend_path "PKG_CONFIG_PATH",
    #                  Formula["brewsci/bio/pygobject3@3.50"].opt_lib/"pkgconfig"

    # Set Boost, RDKit, and FFTW2 root
    boost_prefix = Formula["boost"].opt_prefix
    boost_python_lib = "boost_python314"
    rdkit_prefix = Formula["rdkit"].opt_prefix
    fftw2_prefix = Formula["clipper4coot"].opt_prefix/"fftw2"

    args = %W[
      --prefix=#{prefix}
      --with-enhanced-ligand-tools
      --with-coordgen
      --with-boost=#{boost_prefix}
      --with-boost-libdir=#{boost_prefix}/lib
      --with-gemmi=#{Formula["gemmi"].opt_prefix}
      --with-glm=#{Formula["glm"].opt_prefix}
      --with-rdkit-prefix=#{rdkit_prefix}
      --with-fftw-prefix=#{fftw2_prefix}
      --with-backward
      --with-libdw
      --with-sound
      BOOST_PYTHON_LIB=#{boost_python_lib}
      PYTHON=#{python3}
    ]

    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "./configure", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
    bin.install_symlink libexec/"Maccoot"
    # install reference data
    # install data, #{pkgshare} is /path/to/share/coot
    (pkgshare/"reference-structures").install resource("reference-structures")
    (pkgshare/"lib/data/monomers").install resource("monomers")
  end

  # test block is not tested now.
  test do
    ENV["XDG_STATE_HOME"] = testpath
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    assert_match "Usage: coot", shell_output("#{bin}/coot --help 2>&1")
  end
end
__END__
diff --git a/src/molecule-class-info.h b/src/molecule-class-info.h
index 4a9fb8d0bd..3c634e0fee 100644
--- a/src/molecule-class-info.h
+++ b/src/molecule-class-info.h
@@ -34,6 +34,7 @@
 #endif // HAVE_STRING

 #include <deque>
+#include <iomanip>

 #include "compat/coot-sysdep.h"
