class Genewise < Formula
  # cite Birney_2004: "https://doi.org/10.1101/gr.1865504"
  desc "Aligns proteins or protein HMMs to DNA"
  homepage "https://www.ebi.ac.uk/~birney/wise2/"
  url "https://www.ebi.ac.uk/~birney/wise2/wise2.4.1.tar.gz"
  sha256 "240e2b12d6cd899040e2efbcb85b0d3c10245c255f3d07c1db45d0af5a4d5fa1"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "6fdc8a97b8c15df77d6c6a7cb545ce9f2fa21c14e010e041b5d8eff64b5c20c1" => :sierra
    sha256 "67e56af99ac88549d06a08338a0e953a355d61ab31abd5ce0708a16baab98d75" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    # Use pkg-config glib-2.0 rather than glib-config
    inreplace %w[src/makefile src/corba/makefile
                 src/dnaindex/assembly/makefile src/dnaindex/makefile
                 src/dynlibsrc/makefile src/models/makefile
                 src/network/makefile src/other_programs/makefile
                 src/snp/makefile],
      "glib-config", "pkg-config glib-2.0"

    # getline conflicts with stdio
    inreplace "src/HMMer2/sqio.c", "getline", "getline_ReadSeqVars"

    # Fails to build with GCC 4.4 on Linux
    # undefined reference to `isnumber'
    # patch suggested in http://korflab.ucdavis.edu/datasets/cegma/ubuntu_instructions_1.txt
    inreplace "src/models/phasemodel.c", "isnumber", "isdigit"

    inreplace "src/makefile", "csh welcome.csh", "sh welcome.csh"

    # Fix error: undefined reference to `g_hash_table_foreach_remove'
    inreplace "src/models/makefile", "-ldyna_glib", "-ldyna_glib `pkg-config --libs glib-2.0`"

    system "make", "-C", "src", "all"
    bin.install Dir["src/bin/*"]
    doc.install Dir["docs/*"]
    pkgshare.install Dir["wisecfg/*"]
    bin.env_script_all_files libexec, "WISECONFIGDIR" => pkgshare
  end

  test do
    assert_match "Version", shell_output("#{bin}/genewise -version", 63)
  end
end
