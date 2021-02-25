class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Open-source PyMOL molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.4.0.tar.gz"
  sha256 "5ede4ce2e8f53713c5ee64f5905b2d29bf01e4391da7e536ce8909d6b9116581"
  revision 2
  head "https://github.com/schrodinger/pymol-open-source.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    rebuild 1
    sha256 cellar: :any, catalina:     "12b63c0572b512c2639d2366b3c6cdab15128cf7b71f1a5ff1633fe0f90e4d67"
    sha256               x86_64_linux: "88d616fb0c1a5430441cd00af1bc34d7d04406db029f737d75d7165dea605080"
  end

  depends_on "brewsci/bio/mmtf-cpp"
  depends_on "catch2"
  depends_on "ffmpeg" # enable export mp4 movies
  depends_on "freeglut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libpng"
  depends_on "libxml2"
  depends_on "msgpack"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "sip"

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
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
      --testing
    ]
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "install", *args

    bin.install libexec/"bin/pymol"
  end

  test do
    system "#{bin}/pymol", "-c"
  end
end
