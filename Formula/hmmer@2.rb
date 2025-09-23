class HmmerAT2 < Formula
  # cite Eddy_2009: "https://doi.org/10.1142/9781848165632_0019"
  # cite Johnson_2010: "https://doi.org/10.1186/1471-2105-11-431"
  # cite Eddy_2011: "https://doi.org/10.1371/journal.pcbi.1002195"
  desc "Profile HMM models for protein sequences"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-2.3.2.tar.gz"
  sha256 "d20e1779fcdff34ab4e986ea74a6c4ac5c5f01da2993b14e92c94d2f076828b4"
  license "GPL-2.0-only"
  revision 3

  resource "config.sub" do
    url "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD"
    sha256 "26b852f75a637448360a956931439f7e818bf63150eaadb9b85484347628d1fd"
  end

  resource "config.guess" do
    url "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD"
    sha256 "50205cf3ec5c7615b17f937a0a57babf4ec5cd0aade3d7b3cccbe5f1bf91a7ef"
  end

  def install
    # patch to Makefile.in to coexist with HMMER 3.x
    inreplace "Makefile.in", "cp src/$$file $(BINDIR)/", "cp src/$$file $(BINDIR)/\"$${file}2\""
    inreplace "Makefile.in", "man$(MANSUFFIX)/$$file.$(MANSUFFIX)", "man$(MANSUFFIX)/\"$${file}2\".$(MANSUFFIX)"
    # download config.sub and config.guess from newer autoconf-archive
    # so we can build on newer macOS
    buildpath.install resource("config.sub")
    buildpath.install resource("config.guess")

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--enable-threads", "--enable-lfs"
    system "make"
    system "make", "install", "--always-make"
    pkgshare.install "tutorial", "testsuite"
  end

  test do
    cd pkgshare/"tutorial" do
      assert_match "IYIGNL......NRELTEGDILTVFS.....E.YGVP..VDVILSRD", shell_output("#{bin}/hmmalign2 rrm.hmm rrm.sto")
    end
  end
end
