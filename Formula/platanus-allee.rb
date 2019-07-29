class PlatanusAllee < Formula
  desc "De novo haplotype assembler for heterogenous genomes"
  homepage "http://platanus.bio.titech.ac.jp/platanus2"
  url "http://platanus.bio.titech.ac.jp/?ddownload=348"
  version "2.0.2"
  sha256 "d407a9412a77d1bc8bd4cbd864e734c02d51c9a3f92166c9899a20feed2e98f1"

  depends_on "gcc" # for openmp
  fails_with :clang
  patch :DATA

  def install
    system "make"
    bin.install "platanus_allee"
  end

  test do
    system "#{bin}/platanus_allee", "-v"
  end
end

__END__
diff --git a/baseCommand.cpp b/baseCommand.cpp
index 442c122..832204e 100644
--- a/baseCommand.cpp
+++ b/baseCommand.cpp
@@ -146,7 +146,7 @@ bool BaseCommand::parseArgs(int argc, char **argv)
 int BaseCommand::divideArgvInt(char *args) const
 {
     char *moveArgs = args;
-    for (;moveArgs != '\0'; ++moveArgs) {
+    for (;*moveArgs != '\0'; ++moveArgs) {
         if (isdigit(*moveArgs)) {
             return atoi(moveArgs);
         }

