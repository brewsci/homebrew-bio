class Blat < Formula
  # cite Kent_2002: "https://doi.org/10.1101/gr.229202"
  desc "Genomic sequence search tool"
  homepage "https://genome.ucsc.edu/FAQ/FAQblat.html"
  url "https://hgwdev.cse.ucsc.edu/~kent/src/blatSrc36.zip"
  sha256 "4b0fff006c86dceb7428922bfb4f8625d78fd362d205df68e4ebba04742d2c71"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "176a5d7844d4a0b9609a4677c5937012f18bc8ab5456c6e909ad0ec931a45ad8" => :sierra
    sha256 "8ee3683323642e0e0d3fc1fbd4c7d84b3358a8b74af5833bb6fe1a086690ebbe" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "mysql@5.7"
  depends_on "openssl@1.1"

  def install
    ENV.append_to_cflags "-I#{Formula["libpng"].opt_include}"
    bin.mkpath
    system "make",
      "MYSQLLIBS='-L#{Formula["mysql@5.7"].opt_lib} -lmysqlclient'",
      "MACHTYPE=#{`uname -m`.chomp}",
      "BINDIR=#{bin}"
  end

  test do
    (testpath/"db.fa").write <<~EOS
      >gi|5524211|gb|AAD44166.1| cytochrome b [Elephas maximus maximus]
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOS
    (testpath/"query.fa").write <<~EOS
      >spam
      CLYTHIGRNIYYGSY
    EOS
    system "#{bin}/blat", "-prot", "db.fa", "query.fa", "out.psl"
    assert_match "spam", File.read("#{testpath}/out.psl")
  end
end
