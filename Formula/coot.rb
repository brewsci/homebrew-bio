class Coot < Formula
  desc "Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/source/releases/coot-1.1.11.tar.gz"
  sha256 "6fd2b5a2d1bad5bdeebdb030b552b800df28c0c03608334fe69725379da8eec0"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "5427ded1bc1a72b8230df91339d9c3d22cc2c981182ec942d979e2e4de2007b3"
    sha256 arm64_sonoma:  "fe88074b1051f38510d1dcf1520b1bfea03aa6720a542ee800e7d878c5c94d34"
    sha256 ventura:       "8b11c33425b61062f1126fba25bca82d51f2aa393bd5d86ea0f8e5c2ea788a3a"
    sha256 x86_64_linux:  "d50d4e8fd15c30b2d471f5c735f1f61d9775f08247b3b38b1417446edccabe5b"
  end

  head do
    url "https://github.com/pemsley/coot.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme" # display icons
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "brewsci/bio/clipper4coot"
  depends_on "brewsci/bio/gemmi"
  depends_on "brewsci/bio/gtk4@4.14"
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
  depends_on "harfbuzz"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pango"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"
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
    "python3.12"
  end

  def install
    ENV.cxx11
    ENV.libcxx
    if build.head?
      # libtool -> glibtool for macOS
      inreplace "autogen.sh", "libtool", "glibtool"
      system "./autogen.sh"
    end
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
    boost_python_lib = "boost_python312"
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
