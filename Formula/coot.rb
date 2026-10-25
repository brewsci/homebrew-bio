class Coot < Formula
  desc "Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://github.com/pemsley/coot/archive/refs/tags/Release-1.3.4.tar.gz"
  sha256 "317eb59b759134018d3123414e5c87e6a8883386e3c898838cad94154492faaf"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]
  head "https://github.com/pemsley/coot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_tahoe:   "8070b6df19a0fac9d754be25d684100af8737c014425abd87e257e050e1a280a"
    sha256 arm64_sequoia: "6c491085cf51698b898bfbc3cf0a94281ff01719e6ac175e446c75ab1afabeaa"
    sha256 arm64_sonoma:  "46a390a6258439df501f7c58f7cde610eb84b38f056000864017df3a934a62fc"
    sha256 x86_64_linux:  "90845feaf72d4890d825f3d341c210f16df6fd4142aaca4a0f4e066708a15fe9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "eigen" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clipper4coot"
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"
  depends_on "brewsci/bio/ssm"
  depends_on "cairo"
  depends_on "coordgen"
  depends_on "dwarfutils"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gemmi"
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
  depends_on "maeparser"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openal-soft"
  depends_on "openblas"
  depends_on "pango"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.15"
  depends_on "rdkit"
  depends_on "sqlite"
  depends_on "vte3"
  depends_on "zlib-ng-compat"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "elfutils"
  end

  resource "monomers" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/refmac-monomer-library.tar.gz"
    sha256 "03562eec612103a48bd114cfe0d171943e88f94b84610d16d542cda138e5f36b"
  end

  resource "rdkit-bounds-matrix-builder-details" do
    url "https://raw.githubusercontent.com/rdkit/rdkit/Release_2026_09_1/Code/GraphMol/DistGeomHelpers/BoundsMatrixBuilderDetails.h"
    version "2026.09.1"
    sha256 "1b1c0d298a69ef3c71a9fc43765cb51c057620bd4facbbab97489f5d9251890c"
  end

  resource "reference-structures" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/reference-structures.tar.gz"
    sha256 "44db38506f0f90c097d4855ad81a82a36b49cd1e3ffe7d6ee4728b15109e281a"
  end

  def python3
    "python3.15"
  end

  def install
    # fix issue of https://github.com/pemsley/coot/issues/335
    # include DYLD_FALLBACK_LIBRARY_PATH and GI_TYPELIB_PATH
    glib_opt_lib = formula_opt_lib("glib")
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

    if OS.mac?
      # coot's bare GTK4 window has no Dock icon on macOS. Build a tiny
      # static helper that calls NSApplication#setApplicationIconImage via
      # AppKit, and link it only into the MacCoot binary (see the OS_DARWIN
      # block appended to src/Makefile.am below).
      dock_icon_source = buildpath/"src/coot-macos-dock-icon.mm"
      dock_icon_source.write <<~OBJCPP
        #import <AppKit/AppKit.h>

        extern "C" void set_coot_macos_dock_icon(const char *path) {
          @autoreleasepool {
            NSString *icon_path = [NSString stringWithUTF8String:path];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:icon_path];
            if (image != nil) {
              [[NSApplication sharedApplication] setApplicationIconImage:image];
              [image release];
            }
          }
        }
      OBJCPP
      system ENV.cxx, "-c", dock_icon_source, "-o", "src/coot-macos-dock-icon.o"
      system "ar", "rcs", "src/libcoot-macos-dock-icon.a", "src/coot-macos-dock-icon.o"

      # extern "C" linkage specifications are only valid at namespace scope,
      # so the declaration goes just above startup(), and only the call
      # itself goes inline after gtk_init().
      inreplace "src/startup.cc", "int startup(int argc, char **argv) {", <<~CPP.chomp
        #ifdef __APPLE__
        extern "C" void set_coot_macos_dock_icon(const char *path);
        #endif

        int startup(int argc, char **argv) {
      CPP

      inreplace "src/startup.cc", "gtk_init();", <<~CPP.chomp
        gtk_init();

        #ifdef __APPLE__
           set_coot_macos_dock_icon("#{pkgshare}/coot-dock-icon.icns");
        #endif
      CPP

      inreplace "src/Makefile.am" do |s|
        s.inreplace_string.sub!(/(MacCoot_LDADD\s*=.*?\$\(EMBEDDED_PYTHON_LIBS\))(\nelse\ncoot_1_LDADD)/m) do
          "#{Regexp.last_match(1)} \\\n\tlibcoot-macos-dock-icon.a#{Regexp.last_match(2)}"
        end
      end
      # automake requires linker flags such as -framework to live in
      # _LDFLAGS rather than _LDADD.
      inreplace "src/Makefile.am",
                "MacCoot_LDFLAGS = $(EXPORT_DYNAMIC_FLAG_SPEC)",
                "MacCoot_LDFLAGS = $(EXPORT_DYNAMIC_FLAG_SPEC) -framework AppKit"
    end

    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    if OS.mac?
      inreplace "./configure", "$wl-flat_namespace", ""
      inreplace "./configure", "$wl-undefined ${wl}suppress", "-undefined dynamic_lookup"
    end

    # Get Python location
    xy = Language::Python.major_minor_version python3
    (lib/"python#{xy}/site-packages/homebrew-coot.pth").write "#{libexec/"lib/python#{xy}/site-packages"}\n"
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("numpy")/Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    # Set Boost, RDKit, and FFTW2 root
    boost_prefix = formula_opt_prefix("boost")
    boost_python_lib = "boost_python315"
    rdkit_prefix = formula_opt_prefix("rdkit")
    fftw2_prefix = formula_opt_prefix("clipper4coot")/"fftw2"

    # RDKit 2026.09.1 omits this header from its install list. Use the matching
    # upstream header locally until the RDKit installation is fixed.
    rdkit_header = resource("rdkit-bounds-matrix-builder-details")
    if Formula["rdkit"].version == rdkit_header.version
      rdkit_include = buildpath/"rdkit-include"
      rdkit_header.stage rdkit_include
      ENV.append "CPPFLAGS", "-I#{rdkit_include}"
    end

    args = %W[
      --prefix=#{prefix}
      --with-boost=#{boost_prefix}
      --with-boost-libdir=#{boost_prefix}/lib
      --with-gemmi=#{formula_opt_prefix("gemmi")}
      --with-glm=#{formula_opt_prefix("glm")}
      --with-rdkit-prefix=#{rdkit_prefix}
      --with-fftw-prefix=#{fftw2_prefix}
      --with-backward
      --with-libdw
      --with-netcdf
      --with-sound
      --with-vte
      BOOST_PYTHON_LIB=#{boost_python_lib}
      PYTHON=#{python3}
    ]

    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "./configure", *args
    system "make"
    ENV.deparallelize { system "make", "install" }
    bin.install_symlink libexec/"Maccoot"
    # install the Dock icon referenced by the AppKit helper above. NSImage reads
    # .icns natively, so the multi-resolution icon (16px up to 1024px) is used
    # as-is and the Dock no longer has to upscale a single 256px bitmap.
    pkgshare.install "pixmaps/icons/Coot.icns" => "coot-dock-icon.icns" if OS.mac?
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
