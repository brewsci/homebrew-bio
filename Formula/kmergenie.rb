class Kmergenie < Formula
  # cite Chikhi_2013: "https://doi.org/10.1093/bioinformatics/btt310"
  desc "Estimates the best k-mer length for genome de novo assembly"
  homepage "http://kmergenie.bx.psu.edu/"
  url "http://kmergenie.bx.psu.edu/kmergenie-1.7048.tar.gz"
  sha256 "ca1b6580ffb06803500aa1f7ce8d57b2bee801b7d1901073de5fa2229ab00c6e"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3eee36e39911e3578cb1c4e824be9d342937246a48e604561c0ab88782f3e1a4" => :sierra
    sha256 "3924e202b8e447adb1e08a341db269b8eeb390198d4a6d8a6b033925be1e9b30" => :x86_64_linux
  end

  depends_on "ntcard"
  depends_on "python"
  if OS.mac?
    # brew cask install r-app
  else
    depends_on "r"
  end

  def install
    inreplace "makefile", "python", "python3"
    inreplace ["kmergenie", "scripts/decide", "scripts/generate_report.py"],
      %r{^#!/usr/bin/env python.*$},
      "#!#{Formula["python"].bin/"python3"}"

    args = ["k=121"]
    args << "osx=1" if OS.mac?
    system "make", "specialk", *args

    prefix.install "kmergenie", "readfq.py", "specialk", "scripts", "third_party"
    (prefix/"ntCard").install_symlink Formula["ntcard"].bin/"ntcard"
    bin.install_symlink prefix/"kmergenie", prefix/"specialk"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kmergenie --help")
    assert_match "usage", shell_output("#{bin}/specialk 2>&1")

    if which("Rscript")
      (testpath/"test.fa").write <<~EOS
        >1
        AAAAAACCCCCCGGGGGGTTTTTT
      EOS
      assert_match "No best k found", shell_output("#{bin}/kmergenie test.fa 2>&1", 1)
    end
  end
end
