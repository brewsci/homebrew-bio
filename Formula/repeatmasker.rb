class Repeatmasker < Formula
  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "http://www.repeatmasker.org/"
  url "http://repeatmasker.org/RepeatMasker-open-4-0-7.tar.gz"
  version "4.0.7"
  sha256 "16faf40e5e2f521146f6692f09561ebef5f6a022feb17031f2ddb3e3aabcf166"
  revision 4

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "7fcee4e987b113ca2661261d9e93748dff492004c7e954c50e357026a2701cb7" => :sierra
    sha256 "eaa8d9c36550b03924859a3ef41a6dfcf5b08b2f8c501e20f07db532026a0d00" => :x86_64_linux
  end

  depends_on "blast"
  depends_on "hmmer"
  depends_on "rmblast"
  depends_on "trf"
  unless OS.mac?
    depends_on "cpanminus" => :build
    depends_on "perl"
  end

  def install
    libexec.install Dir["*"]
    if OS.mac?
      perl = "/usr/bin/perl"
      bin.install_symlink "../libexec/RepeatMasker"
    else
      perl = HOMEBREW_PREFIX/"bin/perl"
      ENV["PERL5LIB"] = libexec/"lib/perl5"
      system "cpanm", "--self-contained", "-l", libexec, "Text::Soundex"
      (bin/"RepeatMasker").write_env_script(libexec/"RepeatMasker", :PERL5LIB => ENV["PERL5LIB"])
    end

    # Configure RepeatMasker. The prompts are:
    # PRESS ENTER TO CONTINUE
    # Enter path [ perl ]:
    # REPEATMASKER INSTALLATION DIRECTORY Enter path
    # TRF PROGRAM Enter path
    # 2. RMBlast - NCBI Blast with RepeatMasker extensions: [ Un-configured ]
    # RMBlast (rmblastn) INSTALLATION PATH
    # Do you want RMBlast to be your default search engine for Repeatmasker?
    # 4. HMMER3.1 & DFAM
    # HMMER INSTALLATION PATH Enter path
    # Do you want HMMER to be your default search engine for Repeatmasker?
    # 5. Done
    (libexec/"configure.input").write <<~EOS

      #{perl}
      #{libexec}
      #{HOMEBREW_PREFIX}/bin/trf
      2
      #{HOMEBREW_PREFIX}/bin
      Y
      4
      #{HOMEBREW_PREFIX}/bin
      N
      5
      EOS
    Dir.chdir libexec.to_s do
      system "./configure <configure.input"
    end
  end

  def caveats; <<~EOS
    Congratulations!  RepeatMasker is now ready to use.
    The program is installed with a minimal repeat library
    by default.  This library only contains simple, low-complexity,
    and common artefact ( contaminate ) sequences.  These are
    adequate for use with your own custom repeat library.  If you
    plan to search using common species specific repeats you will
    need to obtain the complete RepeatMasker repeat library from
    GIRI and install it:
      Browse to https://www.girinst.org/server/RepBase/
      Download RepBaseRepeatMaskerEdition-*.tar.gz
      cd #{libexec}
      tar zxvf repeatmaskerlibraries-*.tar.gz
      ./configure <configure.input

    The default aligner is RMBlast. You may reconfigure RepeatMasker
    by running
      cd #{libexec} && ./configure
    EOS
  end

  test do
    assert_match "options", shell_output("#{bin}/RepeatMasker")
  end
end
