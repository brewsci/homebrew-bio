class Kmergenie < Formula
  # cite Chikhi_2013: "https://doi.org/10.1093/bioinformatics/btt310"
  desc "Estimates the best k-mer length for genome de novo assembly"
  homepage "http://kmergenie.bx.psu.edu/"
  url "http://kmergenie.bx.psu.edu/kmergenie-1.7048.tar.gz"
  sha256 "ca1b6580ffb06803500aa1f7ce8d57b2bee801b7d1901073de5fa2229ab00c6e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "667ed710b2d35a2bab83139446e7ab580b8f60f45ad2c5c666aabf917f30cce7" => :sierra_or_later
    sha256 "652b00587d0fa7d803864991726ca8fef08c8d57618d02b0aaab5aab94d83eef" => :x86_64_linux
  end

  depends_on "ntcard"
  depends_on "python"

  def install
    inreplace "makefile", "python", "python3"
    inreplace "kmergenie", %r{^#!/usr/bin/env python.*$}, "#!#{Formula["python"].bin/"python3"}"

    args = ["k=121"]
    args << "osx=1" if OS.mac?
    system "make", "specialk", *args

    prefix.install "kmergenie", "specialk", "scripts", "third_party"
    bin.install_symlink prefix/"kmergenie", prefix/"specialk"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kmergenie --help")
    assert_match "usage", shell_output("#{bin}/specialk 2>&1")
  end
end
