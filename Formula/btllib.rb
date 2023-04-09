class Btllib < Formula
  desc "Bioinformatics Technology Lab common code library in C++ with Python wrappers"
  homepage "https://bcgsc.github.io/btllib/"
  url "https://github.com/bcgsc/btllib/releases/download/v1.5.1/btllib-1.5.1.tar.gz"
  sha256 "0d6316c9fba0d6ded3a11ef59be68100aad74b5f6ac759a56c76c2a520a1c534"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5b4f469db9939fa95912de0834913cf8c62c96abcf3b87bad6967a56296fd4dd"
  end

  depends_on "cmake" => :build
  depends_on "libomp" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "bzip2"
  depends_on "gnu-tar"
  depends_on "gzip"
  depends_on "lrzip"
  depends_on "pigz"
  depends_on "samtools"
  depends_on "wget"
  depends_on "xz"
  depends_on "zip"

  def python3
    "python3.10"
  end

  def install
    system "./compile"
    bin.install Dir["install/bin/*"]
    include.install Dir["install/include/*"]
    lib.install Dir["install/lib/*"]

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    rm_rf Dir["#{lib}/btllib/python/btllib/__pycache__"]
    cd "#{lib}/btllib/python" do
      system python3, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    system "indexlr", "--help"
    system python3, "-c", "'import btllib'"
  end
end
