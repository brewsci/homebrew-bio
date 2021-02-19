class Hssp < Formula
  # cite Touw_2015: "https://doi.org/10.1093/nar/gku1028"
  desc "Create HSSP file"
  homepage "https://github.com/cmbi/xssp"
  url "https://github.com/cmbi/hssp/archive/3.1.5.tar.gz"
  sha256 "9462608ce6b5b92f13a3a8d94b780d85a3cac68ab38449116193754cc22dc5d0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "4ce38b0b1e31fc6d6a227f45c669fc207a86452c651308d20086a8b2a7727544"
    sha256 cellar: :any, x86_64_linux: "13ed6f5a89db289af9b00aad4c61162b9b22150fd800d6cbee3345a980ac6e27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  uses_from_macos "bzip2"

  # This formula does not contain libzeep.
  # If libzeep is not detected, then `mkhssp --fetch-dbrefs` is disabled.
  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
           "--with-boost=#{Formula["boost"].opt_prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert_match "mkhssp version", shell_output("#{bin}/mkhssp --version")
  end
end
