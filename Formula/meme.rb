class Meme < Formula
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  url "http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"
  revision 4

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "81803b3e1fd878c908f91f2f04e85e5916a3766487b54ce545a8d861c88f0c86" => :x86_64_linux
  end

  # Work around the error:
  # ld: file not found: /usr/lib/system/libsystem_darwin.dylib
  depends_on :linux if ENV["CIRCLECI"]

  depends_on "open-mpi" => :optional
  unless OS.mac?
    depends_on "cpanminus" => :build
    depends_on "zlib" => :build
    depends_on "perl"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{libexec}"
    system "make", "install"
    prefix.install "tests"
    perl_files = `grep -l -w "#!/usr/bin/perl" #{bin}/*`.split("\n")
    perl_files.each do |file|
      inreplace file, %r{^#!/usr/bin/perl.*}, "#!/usr/bin/env perl"
    end

    if OS.mac?
      bin.install_symlink libexec/"bin/meme"
    else
      ENV["PERL5LIB"] = libexec/"lib/perl5"
      system "cpanm", "--self-contained", "-l", libexec, "XML::Parser::Expat"
      (bin/"meme").write_env_script(libexec/"bin/meme", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    system bin/"meme", prefix/"tests/common/At.s"
  end
end
