class Rnammer < Formula
  # Lagesen_2007: "https://doi.org/10.1093/nar/gkm160"
  desc "Identify 5s/8s, 16s/18s, and 23s/28s ribosomal RNA"
  homepage "https://www.cbs.dtu.dk/services/RNAmmer/"
  # The tarball may also be downloaded using this web form:
  # https://www.cbs.dtu.dk/cgi-bin/nph-sw_request?rnammer
  url "http://bioinformatics.se/resources_2/rnammer-1.2.src.tar.Z"
  sha256 "c8f0df0c44e3c31b81de5b74de9e6033907976bfdc283ad8c3402af5efc2aae2"

  depends_on "hmmer2"

  # Fix "unknown platform"
  patch :DATA

  def install
    man1.install "man/rnammer.1"
    pkgshare.install "example"
    rm_r "man"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"rnammer", libexec/"core-rnammer"
  end

  def caveats; <<~EOS
    For academic users there is no license fee. For the complete license see
      #{opt_prefix}/LICENSE
    There is also a web service at
      https://www.cbs.dtu.dk/services/RNAmmer/
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rnammer -v 2>&1")
    assert_match "5s_rRNA",
      shell_output("#{bin}/rnammer -S bac -m tsu -f - #{pkgshare}/example/ecoli.fsa")
  end
end

__END__
diff --git a/rnammer b/rnammer
index b3382a9..a51c61d 100755
--- a/rnammer
+++ b/rnammer
@@ -32,10 +32,10 @@ my ($TEMP_WORKING_DIR , $multi,@MOL,%MOL_KEYS,$mol,$kingdom,%FLANK,$gff, $xml ,
 ## PROGRAM CONFIGURATION BEGIN

 # the path of the program
-my $INSTALL_PATH = "/usr/cbs/bio/src/rnammer-1.2";
+my $INSTALL_PATH = "HOMEBREW_PREFIX/opt/rnammer/libexec";

 # The library in which HMMs can be found
-my $HMM_LIBRARY = "$INSTALL_PATH/lib";
+my $HMM_LIBRARY = "$INSTALL_PATH/lib";
 my $XML2GFF = "$INSTALL_PATH/xml2gff";
 my $XML2FSA = "$INSTALL_PATH/xml2fsa";

@@ -46,7 +46,10 @@ my $RNAMMER_CORE     = "$INSTALL_PATH/core-rnammer";
 chomp ( my $uname = `uname`);
 my $HMMSEARCH_BINARY;
 my $PERL;
-if ( $uname eq "Linux" ) {
+if (1) {
+	$HMMSEARCH_BINARY = "HOMEBREW_PREFIX/opt/hmmer2/bin/hmmsearch";
+	$PERL = "perl";
+} elsif ( $uname eq "Linux" ) {
	$HMMSEARCH_BINARY = "/usr/cbs/bio/bin/linux64/hmmsearch";
	$PERL = "/usr/bin/perl";
 } elsif ( $uname eq "IRIX64" ) {
