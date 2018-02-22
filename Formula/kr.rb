class Kr < Formula
  desc "Efficient Estimation of Mutation Distances from Unaligned Genomes"
  homepage "http://guanine.evolbio.mpg.de/cgi-bin/kr2/kr.cgi.pl"
  url "http://guanine.evolbio.mpg.de/kr2/kr_2.0.2.tgz"
  sha256 "ee901bdd3dce329c6478c552d4d2e80ace0139de224524c28aaf00e5d3a0a0fa"

  depends_on "gsl"

  def install
    ENV.deparallelize
    cd "Src/Kr" do
      system "make"
      bin.install "kr64", "kr"
    end
    doc.install "Doc/krDoc.pdf"
    pkgshare.install Dir["Data/*"]
  end

  test do
    assert_match "pairwise", shell_output("#{bin}/kr -h 2>&1")
    assert_match "pairwise", shell_output("#{bin}/kr64 -h 2>&1")
    assert_match "A1+AF00488", shell_output("#{bin}/kr64 #{pkgshare}/hiv42.fasta")
  end
end
