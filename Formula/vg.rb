class Vg < Formula
  # cite Garrison_2018: "https://doi.org/10.1101/234856"
  desc "Tools for working with genome variation graphs"
  homepage "https://github.com/vgteam/vg"
  url "https://github.com/vgteam/vg.git",
    :tag => "v1.6.0",
    :revision => "1f8d1fa24521243546fa12d060b1876cfbf692ab"
  head "https://github.com/vgteam/vg.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "unzip" => :build
  depends_on "xz"
  depends_on "bzip2" unless OS.mac?

  # Fix error: 'operator delete' is unavailable: introduced in macOS 10.12"
  fails_with :clang

  def install
    # Fix error: use of undeclared identifier 'PROTOBUF_CONSTEXPR_VAR'
    ENV.deparallelize

    # xxx ENV["C_INCLUDE_PATH"] = "#{Dir.pwd}/include"
    # xxx ENV["CPLUS_INCLUDE_PATH"] = "#{Dir.pwd}/include"
    # xxx ENV["INCLUDE_PATH"] = "#{Dir.pwd}/include"

    system "make", "LIBTOOL=glibtool", "LIBTOOLIZE=glibtoolize"
    bin.install "bin/vg"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/vg --help")
  end
end
