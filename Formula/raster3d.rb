class Raster3d < Formula
  # cite Bacon_1988: "https://doi.org/10.1016/S0263-7855(98)80030-1"
  # cite Merritt_1994: "https://doi.org/10.1107/S0907444994006396"
  # cite Merritt_1997: "https://doi.org/10.1016/s0076-6879(97)77028-9"
  desc "Set of tools for generating high quality raster images of proteins"
  homepage "https://kali.download/kali/pool/main/r/raster3d"
  url "https://kali.download/kali/pool/main/r/raster3d/raster3d_3.0-8.orig.tar.gz"
  sha256 "cc2c8b2c0a7df61c5810c9e803e1d04433ad525329239679cab73e63e762cbe2"
  license "Artistic-2.0"

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
