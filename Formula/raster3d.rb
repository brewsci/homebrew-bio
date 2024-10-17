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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5bbf48059173bacd209046b42265d6d7267e585d9b14c39f6b0867ce5fa17341"
    sha256 cellar: :any,                 arm64_sonoma:  "97a4e64bab4045b7d37a6092fef2cf257d6e73277952991bfee25432b4e8c089"
    sha256 cellar: :any,                 ventura:       "01f663701f739c316dd2890f340d77a4996e8a251a5d962ae80f93620505d991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91079610ab03c38207a7bea4ff9aa83ef806dd7778e0207c81df192112bafae"
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
