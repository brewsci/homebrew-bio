class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c850299c3c495221818a85c9205c60185c8ed9468d5ec2ed034470bb852229dc"
  license "GPL-3.0-or-later"
  head "https://github.com/vcflib/tabixpp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "3375f908215fb077a8d2f633d0312a1d460ccb58e34fd313ff55376132372222"
    sha256 cellar: :any,                 ventura:      "a9242b67130b567b1209814cfb26c04bbe5c04530063b9a1691e666e6feb80d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28e6351fff814e8c951ef1c9518dd668667f9483e011b25c8ae2bbf518bd4d3e"
  end

  depends_on "htslib"
  depends_on "xz" # For LZMA

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    if OS.mac?
      inreplace "Makefile" do |s|
        s.gsub! "libtabix.so.$(SOVERSION)", "libtabix.$(SOVERSION).dylib"
        s.gsub! "-Wl,-soname", "-Wl,-install_name"
      end
    end
    # Use brewed htslib
    inreplace "Makefile", "-Wl,", "-L#{Formula["htslib"].opt_lib} -lhts -Wl,"
    hts_headers = Formula["htslib"].opt_include/"htslib"
    hts_lib = Formula["htslib"].opt_lib/"libhts.#{OS.mac? ? "dylib" : "a"}"
    libpath = "-L#{Formula["htslib"].opt_lib}"
    system "make", "install",
           "HTS_HEADERS=#{hts_headers}",
           "HTS_LIB=#{hts_lib}",
           "LIBPATH=#{libpath}",
           "DESTDIR= ",
           "PREFIX=#{prefix}"
    prefix.install "test"
  end

  test do
    system opt_bin/"tabix++", prefix/"test/vcf_file.vcf.gz"
  end
end
