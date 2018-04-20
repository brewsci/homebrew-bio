class Proteinortho < Formula
  # cite Lechner_2011: "https://doi.org/10.1186/1471-2105-12-124"
  desc "Detection of orthologs in large-scale analysis"
  homepage "https://www.bioinf.uni-leipzig.de/Software/proteinortho/"
  url "https://www.bioinf.uni-leipzig.de/Software/proteinortho/proteinortho_v5.16b_src.tar.gz"
  version "5.16b"
  sha256 "d220d4af5ffae8190eec462d8b6c941022ce2927391493b7741c6b7db96a80f2"

  depends_on "blast"

  needs :cxx11

  def install
    system "make"
    bin.mkpath
    system "make", "INSTALLDIR=#{bin}", "install"
    Dir["#{bin}/*.pl"].each do |script|
      inreplace script, "#!/usr/bin/perl", "#!/usr/bin/env perl"
    end
    doc.install "manual.html"
    pkgshare.install "tools", "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proteinortho5.pl 2>&1")
  end
end
