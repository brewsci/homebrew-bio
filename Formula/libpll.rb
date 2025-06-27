class Libpll < Formula
  # cite Flouri_2015: "https://doi.org/10.1093/sysbio/syu084"
  desc "Phylogenetic likelihood library"
  homepage "https://github.com/xflouris/libpll"
  url "https://github.com/xflouris/libpll/archive/0.3.2.tar.gz"
  sha256 "45107d59d87be921c522478bb3688beee60dc79154e0b4a183af01122c597132"
  license "AGPL-3.0"
  head "https://github.com/xflouris/libpll.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, sierra:       "6c0db69ccdf356afb339511e1acd31664f2c5742aba5ce0045c7ff6eecdeed6a"
    sha256 cellar: :any, x86_64_linux: "58b69c916fcea6f08e91ce956b5f426416506cf70a0ca13763bf3578b0a014fb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    cp_r doc/"examples"/"heterotachy", testpath
    cd "heterotachy" do
      ENV["CPPFLAGS"] = "-I#{include}/libpll"
      system "make"
      system "./heterotachy"
    end
  end
end
