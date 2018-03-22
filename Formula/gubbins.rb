class Gubbins < Formula
  # cite Croucher_2015: "https://doi.org/10.1093/nar/gku1196"
  desc "Detect recombination in bacteria whole genome alignments"
  homepage "https://github.com/sanger-pathogens/gubbins"
  url "https://github.com/sanger-pathogens/gubbins/archive/v2.3.4.tar.gz"
  sha256 "1d748857aaa51dfbd54fe3ab6047f86f758968f7cadc0351737909ae0f609d41"
  head "https://github.com/sanger-pathogens/gubbins.git"

  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  depends_on "fasttree"
  depends_on "python"
  depends_on "raxml"
  depends_on "zlib" unless OS.mac?

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
    cd "python" do
      system "python", *Language::Python.setup_install_args(libexec)
    end
  end

  test do
    assert_match "recombinations", shell_output("#{bin}/gubbins -h 2>&1")
    assert_match "converge_method", shell_output("run_gubbins.py -h 2>&1")
    assert_match "Hadfield", shell_output("gubbins_drawer.py -h 2>&1")
  end
end
