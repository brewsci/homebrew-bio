class Idba < Formula
  # cite Peng_2012: "https://doi.org/10.1093/bioinformatics/bts174"
  desc "Iterative De Bruijn Graph De Novo Assembler for sequence assembly"
  homepage "https://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  url "https://github.com/loneknightpy/idba/archive/1.1.3.tar.gz"
  sha256 "6b1746a29884f4fa17b110d94d9ead677ab5557c084a93b16b6a043dbb148709"
  revision 2
  head "https://github.com/loneknightpy/idba.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "e46bf1a3c2148adc2234d41cb1a213e5d067aa7cda1799712db83908cfbc71da" => :sierra
    sha256 "0b0bb52ff5136db2addc8619c957d2aebc55a6efc03aec8785efd48bd72fc7ff" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "gcc" if OS.mac? # needs openmp

  fails_with :clang # needs openmp

  resource "lacto-genus" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hku-idba/lacto-genus.tar.gz"
    sha256 "b2496e8b9050c4448057214b9902a5d4db9e0069d480e65af029d53ce167a929"
  end

  def install
    system "aclocal"
    system "autoconf"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    rm_rf Dir["bin/*.dSYM"] if OS.mac?
    # system "make", "install"  # currently does not install everything
    bin.install Dir["bin/idba*"].select { |x| File.executable? x }
    libexec.install Dir["bin/*"].select { |x| File.executable? x }
  end

  test do
    assert_match "Usage", shell_output("#{bin}/idba_ud 2>&1", 1)
    resource("lacto-genus").stage testpath
    cd testpath do
      system libexec/"sim_reads", "220668.fa", "220668.reads-10", "--paired", "--depth", "10"
      system bin/"idba", "-r", "220668.reads-10"
    end
  end
end
