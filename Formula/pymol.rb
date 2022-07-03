class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Open-source PyMOL molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.5.0.tar.gz"
  sha256 "aa828bf5719bd9a14510118a93182a6e0cadc03a574ba1e327e1e9780a0e80b3"
  revision 3
  head "https://github.com/schrodinger/pymol-open-source.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "dffe6fc60b1d2d28bb657a0e71344a902a21deced1bc7fed577ad876bc564958"
    sha256               x86_64_linux: "2d2583807734b6b28347bab925c0a0fb1bf0bcfff8f3e8b6ece250c946f7dabb"
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
  depends_on "python@3.9"
  depends_on "sip"

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
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # install other resources
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # To circumvent an installation error "libxml/xmlwriter.h not found".
    ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
    ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
    # CPPFLAGS freetype2 required.
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    # openvr support not included.
    args = %W[
      --install-scripts=#{libexec}/bin
      --install-lib=#{libexec}/lib/python#{xy}/site-packages
      --glut
      --use-msgpackc=c++11
    ]
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "install", *args
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-pymol.pth").write pth_contents
    bin.install libexec/"bin/pymol"
  end

  test do
    system "#{bin}/pymol", "-c"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import pymol"
  end
end
