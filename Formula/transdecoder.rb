class Transdecoder < Formula
  desc "Identifies candidate coding regions within transcript sequences"
  homepage "https://transdecoder.github.io/"
  url "https://github.com/TransDecoder/TransDecoder/archive/refs/tags/TransDecoder-v5.7.1.tar.gz"
  sha256 "41dd5e95f6ba946ff21340417d867e5e99f123b4035779b25d3cffd20b828a30"
  head "https://github.com/TransDecoder/TransDecoder.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "e042f955488ce81913380ae2090db14f5384ed90e2c9c823b31ff2a92f50feac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "13f7d49edfe061c813960bbb59a7c7c27f6eac82a9c058b34bf1d1f52d095c06"
  end

  depends_on "cpanminus" => :build unless OS.mac?
  uses_from_macos "perl"

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
        (bin/executable).write_env_script(prefix/executable, PERL5LIB: ENV["PERL5LIB"])
      end
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/TransDecoder/TransDecoder/raw/master/sample_data/pasa_example/genome.fasta.gz"
      sha256 "2fcbbf2ca33846c3b4bf72eec7b82c19374df9bf12287422e69ec4c2758796d6"
    end
    resource("homebrew-testdata").stage testpath
    assert_match "Done preparing long ORFs", shell_output("#{bin}/TransDecoder.LongOrfs -t genome.fasta 2>&1")
  end
end
