class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c850299c3c495221818a85c9205c60185c8ed9468d5ec2ed034470bb852229dc"
  license "GPL-3.0-or-later"
  head "https://github.com/vcflib/tabixpp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "5dbe2f53c4055cfd8104b70ce7f59a868ea691d28f18c5ab181c751964811fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fef2b7232b66f4851fba14c0c24ff5f4e579077ddf7b516af9b1d694f5264318"
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
