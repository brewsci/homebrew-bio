class Meme < Formula
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  url "http://meme-suite.org/meme-software/5.0.4/meme-5.0.4.tar.gz"
  sha256 "b5e067c8b9d9fe4a2a35d4f4d053714beb380c0c06b54ed94737dd31d93c4cf4"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "bd12839fa2cab51ddd2165764fee991f9a01f1ade1f766600a1301fbda55dd60" => :x86_64_linux
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
    system "./configure", "--disable-dependency-tracking", "--prefix=#{libexec}", "--with-url=http://meme-suite.org/", "--enable-build-libxml2", "--enable-build-libxslt"
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
