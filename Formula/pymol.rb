class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Open-source PyMOL molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.5.0.tar.gz"
  sha256 "aa828bf5719bd9a14510118a93182a6e0cadc03a574ba1e327e1e9780a0e80b3"
  revision 4
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "5672652144cce38472c4e599eb4148d57ed5b4c52819bb951b5cddffa63f2ef9"
    sha256               x86_64_linux: "4061f0ac6b93afaae09dd923599e6b8851d1f1f13f14d3aaf55de6281dee51e2"
  end

  depends_on "brewsci/bio/mmtf-cpp"
  depends_on "ffmpeg"
  depends_on "freeglut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.10"
  depends_on "sip"

  on_macos do
    depends_on "libomp"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/61/3c/2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057/msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/13/ea/c6a302ccdfdcc1ab200bd2b7561e574329055d2974b1fb7939a7aa374da3/mmtf-python-1.1.2.tar.gz"
    sha256 "a5caa7fcd2c1eaa16638b5b1da2d3276cbd3ed3513f0c2322957912003b6a8df"
  end

  resource "Pmw" do
    url "https://altushost-swe.dl.sourceforge.net/project/pmw/Pmw-2.1.tar.gz"
    sha256 "c35a92a6cabacd866467f7a1a19ab01b8e8175aadfc083c93ac8baf98e92b6ce"
  end

  def install
    python = "python3.10"
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python)

    # install other resources
    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec, python)
      end
    end

    # To circumvent an installation error "libxml/xmlwriter.h not found".
    ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
    ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
    # CPPFLAGS freetype2 required.
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"
    site_packages = Language::Python.site_packages(python)

    args = %W[
      --install-scripts=#{libexec}/bin
      --install-lib=#{libexec/Language::Python.site_packages(python)}
      --glut
      --use-openmp=yes
      --use-msgpackc=c++11
    ]
    system python, "setup.py", "install", *args
    (prefix/site_packages/"homebrew-pymol.pth").write libexec/site_packages
    bin.install libexec/"bin/pymol"
  end

  test do
    system "#{bin}/pymol", "-c"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import pymol"
  end
end
