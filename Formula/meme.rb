class Meme < Formula
  # cite Bailey_2009: "https://doi.org/10.1093/nar/gkp335"
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  url "http://meme-suite.org/meme-software/5.1.0/meme-5.1.0.tar.gz"
  sha256 "46b527cb0eebb6ca21976dcd87aae8a4dd9cf55756679c692fc99bae895d36c9"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "b66235d3ce6851c700bc395dff15f2346234b6e84d750dd9d4d92945a999e01a" => :x86_64_linux
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
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{libexec}",
      "--with-url=http://meme-suite.org/",
      "--enable-build-libxml2",
      "--enable-build-libxslt"
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
