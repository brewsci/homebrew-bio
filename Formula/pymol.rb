class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Open-source PyMOL molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.4.0.tar.gz"
  sha256 "5ede4ce2e8f53713c5ee64f5905b2d29bf01e4391da7e536ce8909d6b9116581"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "ce4f0acf8a97da25c6a67894a6afcb69c48a78497d4d3fd2e367b134c1785472" => :x86_64_linux
  end

  depends_on "brewsci/bio/mmtf-cpp"
  depends_on "catch2"
  depends_on "ffmpeg" # enable export a mp4 movie
  depends_on "freeglut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libpng"
  depends_on "msgpack"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "sip"

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/13/ea/c6a302ccdfdcc1ab200bd2b7561e574329055d2974b1fb7939a7aa374da3/mmtf-python-1.1.2.tar.gz"
    sha256 "a5caa7fcd2c1eaa16638b5b1da2d3276cbd3ed3513f0c2322957912003b6a8df"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/81/9c/0036c66234482044070836cc622266839e2412f8108849ab0bfdeaab8578/msgpack-0.6.1.tar.gz"
    sha256 "4008c72f5ef2b7936447dcb83db41d97e9791c83221be13d5e19db0796df1972"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/8a/20/6eca772d1a5830336f84aca1d8198e5a3f4715cd1c7fc36d3cc7f7185091/msgpack-python-0.5.6.tar.gz"
    sha256 "378cc8a6d3545b532dfd149da715abae4fda2a3adb6d74e525d0d5e51f46909b"
  end

  resource "msgpack-tool" do
    url "https://files.pythonhosted.org/packages/73/0c/55e4294143ba6781936c799ff13181db9109b161a8d8fc9b50eec45e1134/msgpack-tool-0.0.1.tar.gz"
    sha256 "4a5df9350275b006d36bfb5cf792aaee363b8cff80a6544c8d4b4a924944787f"
  end

  resource "Pmw" do
    url "https://files.pythonhosted.org/packages/e7/20/8d0c4ba96a5fe62e1bcf2b8a212ccfecd67ad951e8f3e89cf147d63952aa/Pmw-2.0.1.tar.gz"
    sha256 "0b9d28f52755a7a081b44591c3dd912054f896e56c9a627db4dd228306ad1120"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # install other resources
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # To circumvent an installation error "libxml/xmlwriter.h not found".
    unless OS.mac?
      ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
      ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
      ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"
    end

    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}"

    # Note: openvr support is not included.
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
