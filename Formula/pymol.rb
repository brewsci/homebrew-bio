class Pymol < Formula
  include Language::Python::Virtualenv
  desc "molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.2.0.tar.gz"
  sha256 "58d910103dc494c49c86bc8fd6cd94b1a030647f9d72f69fbd7d7ad25fb11233"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "ff0a40dfad3132faa2ff2d7db88831987b548da177bfcf646bd606df88234883" => :x86_64_linux
  end

  depends_on "freeglut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libpng"
  depends_on "msgpack"
  depends_on "pyqt"
  depends_on "python"
  depends_on "sip"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d5/6e/f00492653d0fdf6497a181a1c1d46bbea5a2383e7faf4c8ca6d6f3d2581d/numpy-1.14.5.zip"
    sha256 "a4a433b3a264dbc9aa9c7c241e87c0358a503ea6394f8737df1683c7c9a102ac"
  end

  resource "mmtf-python" do
    url "https://files.pythonhosted.org/packages/13/ea/c6a302ccdfdcc1ab200bd2b7561e574329055d2974b1fb7939a7aa374da3/mmtf-python-1.1.2.tar.gz"
    sha256 "a5caa7fcd2c1eaa16638b5b1da2d3276cbd3ed3513f0c2322957912003b6a8df"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz"
    sha256 "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3"
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
    unless OS.mac?
      # comment out glDebugMessageCallback if CentOS 7
      # https://github.com/schrodinger/pymol-open-source/issues/2
      inreplace "layer5/PyMOL.cpp",
      "glDebugMessageCallback(gl_debug_proc, NULL);",
      "// glDebugMessageCallback(gl_debug_proc, NULL); //"
    end

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    # install other resources
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    # To circumvent an installation error "libxml/xmlwriter.h not found".
    unless OS.mac?
      ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
      ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}/libxml2"
      ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"
    end

    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}"

    args = %W[
      --install-scripts=#{libexec}/bin
      --install-lib=#{libexec}/lib/python#{xy}/site-packages
      --pyqt PyQt5
    ]
    args << "--osx-frameworks" if OS.mac?
    system "python3", "setup.py", "install", *args

    bin.install libexec/"bin/pymol"
  end

  test do
    system "#{bin}/pymol", "-c"
  end
end
