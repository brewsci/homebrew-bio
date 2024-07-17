class Coot < Formula
  include Language::Python::Virtualenv

  desc "Crystallographic Object-Oriented Toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/source/releases/coot-1.1.09.tar.gz"
  sha256 "8837bf97d5c68052dfdac901025e37d327e57c66fa1c54b8883a0d133a154d0a"
  license any_of: ["GPL-3.0-only", "LGPL-3.0-only", "GPL-2.0-or-later"]

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
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"
  depends_on "brewsci/bio/raster3d"
  depends_on "brewsci/bio/ssm"
  depends_on "cairo"
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

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "monomers" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/refmac-monomer-library.tar.gz"
    sha256 "03562eec612103a48bd114cfe0d171943e88f94b84610d16d542cda138e5f36b"
  end

  resource "reference-structures" do
    url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/reference-structures.tar.gz"
    sha256 "44db38506f0f90c097d4855ad81a82a36b49cd1e3ffe7d6ee4728b15109e281a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
    # Install Python dependencies
    venv = virtualenv_create(libexec, python3)
    %w[certifi charset-normalizer idna requests urllib3].each do |r|
      venv.pip_install resource(r)
    end
    (lib/"python#{xy}/site-packages/homebrew-coot.pth").write "#{libexec/"lib/python#{xy}/site-packages"}\n"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # Set Boost, RDKit, and FFTW2 root
    boost_prefix = Formula["boost"].opt_prefix
    boost_python_lib = "boost_python312-mt"
    rdkit_prefix = Formula["rdkit"].opt_prefix
    fftw2_prefix = Formula["clipper4coot"].opt_prefix/"fftw2"

    # Fix libdwarf version
    inreplace "./configure", "libdwarf >= 0.7", "libdwarf <= 0.11" unless build.head?
    args = %W[
      --prefix=#{prefix}
      --with-enhanced-ligand-tools
      --with-boost=#{boost_prefix}
      --with-boost-libdir=#{boost_prefix}/lib
      --with-rdkit-prefix=#{rdkit_prefix}
      --with-fftw-prefix=#{fftw2_prefix}
      --with-backward
      --with-libdw
      BOOST_PYTHON_LIB=#{boost_python_lib}
    ]

    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "./configure", *args
    system "make"
    # Add shebang to coot
    inreplace "src/coot", "\nexport LC_ALL=C", "#!/bin/bash\nexport LC_ALL=C" unless build.head?
    ENV.deparallelize { system "make", "install" }
    bin.install_symlink libexec/"Maccoot"
    # install reference data
    # install data, #{pkgshare} is /path/to/share/coot
    (pkgshare/"reference-structures").install resource("reference-structures")
    (pkgshare/"lib/data/monomers").install resource("monomers")
  end

  # test block is not tested now.
  test do
    assert_match "Usage: coot", shell_output("#{bin}/coot --help 2>&1")
  end
end
