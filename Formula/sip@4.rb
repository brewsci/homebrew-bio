class SipAT4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to create Python bindings for C and C++ libraries"
  homepage "https://python-sip.readthedocs.io/en/latest/"
  url "https://www.riverbankcomputing.com/static/Downloads/sip/4.19.25/sip-4.19.25.tar.gz"
  sha256 "b39d93e937647807bac23579edbff25fe46d16213f708370072574ab1f1b4211"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  keg_only :versioned_formula

  depends_on "python-setuptools" => :build
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  patch do
    url "https://sources.debian.org/data/main/s/sip4/4.19.25%2Bdfsg-5/debian/patches/py_ssize_t_clean.diff"
    sha256 "55bbaa04ab4803a379d8f713eb495bdbf514b895a533ddb6ed2ccd6762ca9f25"
  end

  patch do
    url "https://sources.debian.org/data/main/s/sip4/4.19.25%2Bdfsg-5/debian/patches/sip-4.19.25-pyframe_getback.patch"
    sha256 "8183fc2764210b08cb29482331da761b61bd4d646ce02b873de2bc0eb84d1ed2"
  end

  patch do
    url "https://sources.debian.org/data/main/s/sip4/4.19.25%2Bdfsg-5/debian/patches/fix_use_after_free.patch"
    sha256 "56fac0fd47eae5dec46202e01806e747002ddfd8cc90e7a60dc6d4ecddca5733"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create libexec, which(python3)
    venv.pip_install resources
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --bindir=#{bin}
      --incdir=#{include}
      --destdir=#{site_packages}
      --sipdir=#{share}/sip
      --sip-module
      PyQt5.sip
    ]
    args << "--deployment-target=#{MacOS.version}" if OS.mac?
    system venv.root/"bin/python", "configure.py", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (prefix/"share/sip").mkpath
  end

  test do
    (testpath/"test.h").write <<~EOS
      #pragma once
      class Test {
      public:
        Test();
        void test();
      };
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "test.h"
      #include <iostream>
      Test::Test() {}
      void Test::test()
      {
        std::cout << "Hello World!" << std::endl;
      }
    EOS
    (testpath/"test.sip").write <<~EOS
      %Module test
      class Test {
      %TypeHeaderCode
      #include "test.h"
      %End
      public:
        Test();
        void test();
      };
    EOS
    linker_flag = if OS.mac?
      "-Wl,-install_name,#{testpath}/libtest.dylib"
    else
      "-Wl,-soname,#{testpath}/libtest.so"
    end

    system ENV.cxx, "-fPIC", "-shared", linker_flag,
                    "-o", "libtest.dylib", "test.cpp"
    system bin/"sip", "-b", "test.build", "-c", ".", "test.sip"
  end
end
