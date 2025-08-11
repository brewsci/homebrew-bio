class Psipred < Formula
  # cite Jones_1999: "https://doi.org/10.1006/jmbi.1999.3091"
  desc "Protein Secondary Structure Predictor"
  homepage "https://github.com/psipred/psipred"
  url "https://github.com/psipred/psipred/archive/refs/tags/v4.0.tar.gz"
  sha256 "0954b3e28dda4ae350bdb9ebe9eeb3afb3a6d4448cf794dac3b4fde895c3489b"

  # Freely usable for academic and teaching purposes (research-only license)
  license :cannot_represent

  depends_on "brewsci/bio/blast-legacy"
  depends_on "tcsh"

  def install
    (pkgshare/"data").mkpath
    (pkgshare/"data").install Dir["data/*"]

    cd "src" do
      inreplace "Makefile", /CC.*= cc/, ""

      inreplace "sspred_avpred.c" do |s|
        s.gsub!(/^void[[:space:]]\+\*calloc.*malloc.*;/, "")
        s.gsub!(/main/, "int main")
        s.prepend "#include <stdlib.h>\n"
      end

      system "make"
      system "make", "install"
    end

    bin.install Dir["bin/*"]

    inreplace "runpsipred_single" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set execdir = ./bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ./data", "set datadir = #{share}/psipred/data"
    end

    inreplace "runpsipred" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set ncbidir = /usr/local/bin", "set ncbidir = #{HOMEBREW_PREFIX}/bin"
      s.gsub! "set execdir = ./bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ./data", "set datadir = #{share}/psipred/data"
    end

    inreplace "BLAST+/runpsipredplus" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set ncbidir = /usr/local/bin", "set ncbidir = #{HOMEBREW_PREFIX}/bin"
      s.gsub! "set execdir = ../bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ../data", "set datadir = #{share}/psipred/data"
    end

    bin.install "runpsipred_single", "runpsipred", "BLAST+/runpsipredplus"

    (pkgshare/"example").install Dir["example/*"]
  end

  test do
    cp Dir[pkgshare/"example/*"], testpath
    system "tcsh", "#{bin}/runpsipred_single", "#{testpath}/example.fasta"
    assert_predicate testpath/"example.ss2", :exist?
    assert_predicate testpath/"example.horiz", :exist?
  end
end
