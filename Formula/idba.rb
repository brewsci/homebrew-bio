class Idba < Formula
  # cite Peng_2012: "https://doi.org/10.1093/bioinformatics/bts174"
  desc "Iterative De Bruijn Graph De Novo Assembler for sequence assembly"
  homepage "https://i.cs.hku.hk/~alse/hkubrg/projects/idba/"
  url "https://github.com/loneknightpy/idba/archive/1.1.3.tar.gz"
  sha256 "6b1746a29884f4fa17b110d94d9ead677ab5557c084a93b16b6a043dbb148709"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/loneknightpy/idba.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "094b46cbcb3fe54222cb940f605d5e656864c654f231294c890e98528378eea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3c0b9b2d9a30c1833985040eae10e212ea78faa7c1dc37b52a661a2b9a194913"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_macos do
    depends_on "gcc@9" # needs openmp
  end

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
