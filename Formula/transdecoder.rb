class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder/archive/TransDecoder-v5.0.2.tar.gz"
  sha256 "c3946c07ae21857e5a35d76083b21e925b43bba2dee02db14d31b65942302298"
  head "https://github.com/TransDecoder/TransDecoder.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "17f2e7de9352f9735ea93b9bdb6da49c9ec869010678cf3a5e178b661c19cf94" => :sierra_or_later
    sha256 "67ce07e6e66232ca8a8543867f137f3b1f5a5c5a0fe3d9b7613907e86460250d" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "cpanminus" => :build
    depends_on "perl"
  end

  def install
    system "make"
    rm "Makefile"
    prefix.install Dir["*"]
    executables = "TransDecoder.LongOrfs", "TransDecoder.Predict"
    if OS.mac?
      executables.each do |executable|
        bin.write_exec_script prefix/executable
      end
    else
      ENV["PERL5LIB"] = libexec/"lib/perl5"
      system "cpanm", "--self-contained", "-l", libexec, "URI::Escape"
      executables.each do |executable|
        (bin/executable).write_env_script(prefix/executable, :PERL5LIB => ENV["PERL5LIB"])
      end
    end
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.LongOrfs 2>&1", 1)
    assert_match "USAGE", shell_output("#{bin}/TransDecoder.Predict 2>&1", 1)
  end
end
