class Raster3d < Formula
  # cite Bacon_1988: "https://doi.org/10.1016/S0263-7855(98)80030-1"
  # cite Merritt_1994: "https://doi.org/10.1107/S0907444994006396"
  # cite Merritt_1997: "https://doi.org/10.1016/s0076-6879(97)77028-9"
  desc "Set of tools for generating high quality raster images of proteins"
  homepage "http://www.bmsc.washington.edu/raster3d"
  url "http://www.bmsc.washington.edu/raster3d/Raster3D_3.0-7.tar.gz"
  sha256 "f566b499fee341db3a95229672c6afdbdb69da7faabdbe34f6e0d332d766160c"
  license "Artistic-2.0"
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "bee2e4e6d1d2a45362b79531593e0dcd87d3d91880e14ecf4f4382dd99c01c94"
    sha256 cellar: :any,                 ventura:      "85922e4f1bed55896e2b9a5c232e2de3c20379bdc6e681db0269faa70e79281e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "471eaf158d04dfa8509b49327b845d962785250f47a3fa3c7c735a3b23b6c4fd"
  end

  depends_on "gcc"
  depends_on "gd"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "make", "linux"

    inreplace "Makefile.incl" do |s|
      s.gsub! "prefix  = /usr/local", "prefix  = #{prefix}"
      s.gsub! "INCDIRS  =	-I/usr/include -I/usr/local/include", "INCDIRS  = -I#{HOMEBREW_PREFIX}/include"
      s.gsub! "LIBDIRS  =	-L/usr/local/lib", "LIBDIRS  = -L#{HOMEBREW_PREFIX}/lib"
      s.gsub! "mandir  = $(prefix)/man/manl", "mandir  = #{man}/manl"
    end

    # Need SDKROOT for macOS
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # ENV.depearallelize is required for compilation of 'make render'
    ENV.deparallelize { system "make all && make install" }
    cp_r "examples", prefix
  end

  def caveats
    <<~EOS
      Add R3D_LIB to your system-wide initialization of environmental variables:
      export R3D_LIB=#{prefix}/share/Raster3D/materials # for bash|ksh|zsh
      setenv R3D_LIB /usr/local/share/Raster3D/materials # for csh
    EOS
  end

  test do
    assert_match "outfile.ps", shell_output("#{bin}/avs2ps -h 2>&1", 255)
  end
end
