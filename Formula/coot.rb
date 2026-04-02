class Coot < Formula
  desc "Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://github.com/pemsley/coot/archive/refs/tags/Release-1.2.tar.gz"
  sha256 "ebf19951382151a53ed9c176aea0cf732994235478c64be611cd3f6fc0bdc9ea"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]
  head "https://github.com/pemsley/coot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe: "8eae32dcd7081b1ffe69896168f84e7b7c42583facd6bc7bd0be02e7e5cd5415"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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
    # fix issue of https://github.com/pemsley/coot/issues/335
    # include DYLD_FALLBACK_LIBRARY_PATH and GI_TYPELIB_PATH
    glib_opt_lib = Formula["glib"].opt_lib
    if OS.mac?
      inreplace "src/coot.in",
                "data/syminfo.lib",
                "data/syminfo.lib\nexport DYLD_FALLBACK_LIBRARY_PATH=#{glib_opt_lib}:#{HOMEBREW_PREFIX}/lib" \
                "${DYLD_FALLBACK_LIBRARY_PATH:+:$DYLD_FALLBACK_LIBRARY_PATH}"
    end
    inreplace "src/coot.in",
              "exec_prefix=",
              "export GI_TYPELIB_PATH=#{HOMEBREW_PREFIX}/lib/girepository-1.0${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}" \
              "\nexec_prefix="
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
    # Set Boost, RDKit, and FFTW2 root
    boost_prefix = Formula["boost"].opt_prefix
    boost_python_lib = "boost_python314"
    rdkit_prefix = Formula["rdkit"].opt_prefix
    fftw2_prefix = Formula["clipper4coot"].opt_prefix/"fftw2"

    args = %W[
      --prefix=#{prefix}
      --with-enhanced-ligand-tools
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
