class BoostPython3AT187 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.87.0/boost-1.87.0-b2-nodocs.tar.xz"
  sha256 "3abd7a51118a5dd74673b25e0a3f0a4ab1752d8d618f4b8cea84a603aeecc680"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "5efbd77a69ec4c938fd5bb4c8d0e7918d7457e2f326f6acfc8f3784f0831fa3b"
    sha256 cellar: :any,                 arm64_sonoma:  "097b19631873640deb6a556c52bb3a93e3b651730190a4173d4755a644278c33"
    sha256 cellar: :any,                 ventura:       "4ad31281ab310f17cf5fb94af4753568556ee697b7136cdbb6bb040a5df115da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4a15cb5c2e92c3a9dc79d8a00d3b22be511c360d4f1dabd7bc79969c0ac7fa8"
  end

  keg_only :versioned_formula

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "linkflags=-Wl,-dead_strip_dylibs" if OS.mac?

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version python3
    py_prefix = if OS.mac?
      Formula["python@#{pyver}"].opt_frameworks/"Python.framework/Versions"/pyver
    else
      Formula["python@#{pyver}"].opt_prefix
    end

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using #{OS.mac? ? "darwin" : "gcc"} : : #{ENV.cxx} ;
      using python : #{pyver}
                   : #{python3}
                   : #{py_prefix}/include/python#{pyver}
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}",
                             "--libdir=#{lib}",
                             "--with-libraries=python",
                             "--with-python=#{python3}",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3/lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install buildpath.glob("install-python3/lib/*{python,numpy}*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/*{python,numpy}*")
  end

  test do
    (testpath/"hello.cpp").write <<~CPP
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    CPP

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system ENV.cxx, "-shared", "-fPIC", "-std=c++14", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~PYTHON
      import hello
      print(hello.greet())
    PYTHON
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
