class Psipred < Formula
  # cite Jones_1999: "https://doi.org/10.1006/jmbi.1999.3091"
  desc "Protein Secondary Structure Predictor"
  homepage "https://github.com/psipred/psipred"
  url "https://github.com/psipred/psipred/archive/refs/tags/v4.0.tar.gz"
  sha256 "ce4c901c8f152f6e93e4f70dc8079a5432fc64d02bcc0215893e33fbacb1fed2"

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
        s.gsub!(/void\s+\*calloc\(\),\s*\*malloc\(\);/, "")
        s.gsub!("main", "int main")
        s.gsub!(/^/, "#include <stdlib.h>\n")
      end

      system "make"
      system "make", "install"
      bin.install Dir["../bin/*"]
    end

    inreplace "runpsipred_single" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set execdir = ./bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ./data", "set datadir = #{pkgshare}/data"
    end

    inreplace "runpsipred" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set ncbidir = /usr/local/bin", "set ncbidir = #{HOMEBREW_PREFIX}/bin"
      s.gsub! "set execdir = ./bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ./data", "set datadir = #{pkgshare}/data"
    end

    inreplace "BLAST+/runpsipredplus" do |s|
      s.gsub! "#!/bin/tcsh", "#!/usr/bin/env tcsh"
      s.gsub! "set ncbidir = /usr/local/bin", "set ncbidir = #{HOMEBREW_PREFIX}/bin"
      s.gsub! "set execdir = ../bin", "set execdir = #{bin}"
      s.gsub! "set datadir = ../data", "set datadir = #{pkgshare}/data"
    end

    bin.install "runpsipred_single", "runpsipred", "BLAST+/runpsipredplus"
    (pkgshare/"example").install Dir["example/*"]
  end

  test do
    cp Dir[pkgshare/"example/*"], testpath
    system "tcsh", "#{bin}/runpsipred_single", "#{testpath}/example.fasta"
    assert_path_exists testpath/"example.ss2"
    assert_path_exists testpath/"example.horiz"
  end
end
