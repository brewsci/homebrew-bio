class Blat < Formula
  # cite Kent_2002: "https://doi.org/10.1101/gr.229202"
  desc "Genomic sequence search tool"
  homepage "https://genome.ucsc.edu/FAQ/FAQblat.html"

  url "http://hgwdev.cse.ucsc.edu/~kent/src/blatSrc36.zip"
  sha256 "4b0fff006c86dceb7428922bfb4f8625d78fd362d205df68e4ebba04742d2c71"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "3cc1890800350138e4a7d0db4fe9dfef2b5685d07957972f6b522f6eb274cc96" => :sierra
    sha256 "97e2bc6d6fa598620ba8815c37d0cef1c106cea310a4c8e15295138e5ed88a18" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "mysql"
  depends_on "openssl"

  def install
    ENV.append_to_cflags "-I#{Formula["libpng"].opt_include}"
    bin.mkpath
    system "make", "MACHTYPE=#{`uname -m`.chomp}", "BINDIR=#{bin}"
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
