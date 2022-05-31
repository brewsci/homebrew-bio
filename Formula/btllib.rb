class Btllib < Formula
  desc "Bioinformatics Technology Lab common code library in C++ with Python wrappers"
  homepage "https://bcgsc.github.io/btllib/"
  url "https://github.com/bcgsc/btllib/releases/download/v1.4.4/btllib-1.4.4.tar.gz"
  sha256 "40ff89060210d9640b3d7b9b26725e20841ba7bc6517b96767114953a13d074f"
  license "GPL-3.0-or-later"

  # Build dependencies
  depends_on "cmake" => :build
  depends_on "libomp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8" => :build

  # Runtime dependencies
  depends_on "bzip2"
  depends_on "gnu-tar"
  depends_on "gzip"
  depends_on "lrzip"
  depends_on "pigz"
  depends_on "samtools"
  depends_on "wget"
  depends_on "xz"
  depends_on "zip"

  def install
    system "./compile"
    bin.install Dir["install/bin/*"]
    include.install Dir["install/include/*"]
    lib.install Dir["install/lib/*"]

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    rm_rf Dir["#{lib}/btllib/python/btllib/__pycache__"]
    cd "#{lib}/btllib/python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system "indexlr", "--help"
    system "python3", "-c", "'import btllib'"
  end
end
