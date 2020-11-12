class Kr < Formula
  desc "Efficient Estimation of Mutation Distances from Unaligned Genomes"
  homepage "http://guanine.evolbio.mpg.de/cgi-bin/kr2/kr.cgi.pl"
  url "http://guanine.evolbio.mpg.de/kr2/kr_2.0.2.tgz"
  sha256 "ee901bdd3dce329c6478c552d4d2e80ace0139de224524c28aaf00e5d3a0a0fa"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3fb83fea4c6f15012261667edc671ca7894d8aab617345ddfb97ae9bea3bb514" => :sierra
    sha256 "af439d0913c58ad15ba0cf137fad2d1a3148f562b798aa3d4e3b37c0bfd6785a" => :x86_64_linux
  end

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
