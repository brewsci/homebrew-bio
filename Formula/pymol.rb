class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Open-source PyMOL molecular visualization system"
  homepage "https://pymol.org/"
  url "https://github.com/schrodinger/pymol-open-source/archive/v2.3.0.tar.gz"
  sha256 "62aa21fafd1db805c876f89466e47513809f8198395e1f00a5f5cc40d6f40ed0"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "8621be3863ecfbf5e0140240d8a5bd648aea59a175a45766a57b64b089956db9" => :x86_64_linux
  end

  depends_on "freeglut"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libpng"
  depends_on "mmtf-cpp"
  depends_on "msgpack"
  depends_on "pyqt"
  depends_on "python"
  depends_on "sip"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/3a/20/c81632328b1a4e1db65f45c0a1350a9c5341fd4bbb8ea66cdd98da56fe2e/numpy-1.15.0.zip"
    sha256 "f28e73cf18d37a413f7d5de35d024e6b98f14566a10d82100f9dc491a7d449f9"
  end

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
      --glut
      --use-msgpackc=c++11
    ]
    args << "--osx-frameworks" if OS.mac?
    # Reduce memory usage for CircleCI.
    args << "--jobs=4" if ENV["CIRCLECI"]
    system "python3", "setup.py", "install", *args

    bin.install libexec/"bin/pymol"
  end

  test do
    system "#{bin}/pymol", "-c"
  end
end
