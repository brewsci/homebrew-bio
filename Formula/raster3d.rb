class Raster3d < Formula
  # cite Bacon_1988: "https://doi.org/10.1016/S0263-7855(98)80030-1"
  # cite Merritt_1994: "https://doi.org/10.1107/S0907444994006396"
  # cite Merritt_1997: "https://doi.org/10.1016/s0076-6879(97)77028-9"
  desc "Set of tools for generating high quality raster images of proteins"
  homepage "http://www.bmsc.washington.edu/raster3d"
  url "http://www.bmsc.washington.edu/raster3d/Raster3D_3.0-7.tar.gz"
  sha256 "f566b499fee341db3a95229672c6afdbdb69da7faabdbe34f6e0d332d766160c"
  license "Artistic-2.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, catalina:     "aa224cf7f584811b12f0af4e405aa8c262511883df47511e3db3fc0ee82220e2"
    sha256               x86_64_linux: "1d1919339d6408189c107a6c834a4299fd7fb349f1d31b66573bee996d53149b"
  end

  depends_on xcode: :build
  depends_on "gcc@9"
  depends_on "gd"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "make", "linux"

    inreplace "Makefile.incl" do |s|
      s.gsub! "prefix  = /usr/local", "prefix  = #{prefix}"
      s.gsub! "mandir  = $(prefix)/man/manl", "mandir  = #{man}/manl"
      s.gsub! "CC = gcc", "CC = #{Formula["gcc@9"].opt_bin}/gcc-9" # Use GNU compiler
      s.gsub! "FC = gfortran", "FC = #{Formula["gcc@9"].opt_bin}/gfortran-9" # Use GNU compiler
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
