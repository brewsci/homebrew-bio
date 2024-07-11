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
    sha256 cellar: :any,                 monterey:     "3638617b2836308831b08c24f4ec7cfccc242194501db85da4b6b502e3dd28f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24bb4867e9b4fce841a4db39d20a26823d0e8c9d4575d63c9e87f9b667204aae"
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
