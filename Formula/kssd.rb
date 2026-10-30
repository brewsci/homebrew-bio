class Kssd < Formula
  desc "K-mer substring space sampling/shuffling decomposition"
  homepage "https://github.com/yhg926/public_kssd"
  url "https://github.com/yhg926/public_kssd/archive/refs/tags/v2.21.tar.gz"
  sha256 "2f6217b6e685dbe15c9aa4fa9a7eeb225651eb608f34799efea4ce84e2d0fd86"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ef105327189bf598e7560fd87b5ab1defab47fdd63d19fe95b41a436d6b340f1"
  end

  # https://github.com/yhg926/public_kssd/issues/2
  depends_on :linux
  depends_on "zlib"

  # Fix a heap off-by-one (long_domain buffer too small by 1) that aborts with
  # "buffer overflow detected" under glibc _FORTIFY_SOURCE=3, and bump the
  # internal version banner (upstream left it at 2.2).
  patch :DATA

  def install
    system "make"
    bin.install "kssd"
    pkgshare.install "test_fna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kssd -V 2>&1")
  end
end
__END__
--- a/kssd.c
+++ b/kssd.c
@@ -17,7 +17,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include "global_basic.h"
-const char *argp_program_version = "kssd version 2.2";
+const char *argp_program_version = "kssd version 2.21";
 const char *argp_program_bug_address = "yhg926@gmail.com";
 int main(int argc, char** argv)
 {
@@ -26,7 +26,7 @@
  const char subcommand_n[] = "<subcommand>";
   domain = (char*) malloc(strlen(argv[0])+1);
   strcpy(domain,argv[0]);
-  long_domain = (char*) malloc( strlen(domain) + strlen(subcommand_n) + 1);
+  long_domain = (char*) malloc( strlen(domain) + strlen(subcommand_n) + 2);
   snprintf(long_domain,strlen(domain) + strlen(subcommand_n) + 2,"%s %s",domain,subcommand_n);
   cmd_global(argc, argv);
   return 0;
