class Raxml < Formula
  # cite Stamatakis_2014: "https://doi.org/10.1093/bioinformatics/btu033"
  desc "Maximum likelihood analysis of large phylogenies"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.12.tar.gz"
  sha256 "338f81b52b54e16090e193daf36c1d4baa9b902705cfdc7f4497e3e09718533b"
  head "https://github.com/stamatak/standard-RAxML.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d399bf6f9e9e84831182e64687d2b21fbebead01126e9337211cc4198f0b8ec9" => :sierra
    sha256 "3c091cd8095130a9e14e5c44ccc36fd0ae19f053fad65097cd90f1dc83bc245d" => :x86_64_linux
  end

  depends_on "gcc" # gfortran
  depends_on "open-mpi" => :recommended unless OS.mac? # uses Linux-specific APIs

  def install
    stems = %w[SSE3 SSE3.PTHREADS]
    stems += %w[AVX AVX.PTHREADS] if Hardware::CPU.avx?
    stems += %w[AVX2 AVX2.PTHREADS] if Hardware::CPU.avx2?
    if build.with? "mpi"
      stems += %w[SSE3.MPI SSE3.HYBRID]
      stems += %w[AVX.MPI AVX.HYBRID] if Hardware::CPU.avx?
      stems += %w[AVX2.MPI AVX2.HYBRID] if Hardware::CPU.avx2?
    end
    stems.each do |f|
      system "make", "-f", "Makefile.#{f}.gcc"
      rm Dir["*.o"]
    end
    bin.install Dir["raxmlHPC-*"]
  end

  test do
    (testpath/"aln.phy").write <<~EOS
      4 20
      Cow       CACCAATCATAGAAGAACTA
      Carp      TACCCGTTATAGAGGAACTT
      Chicken   CCCCCATCATAGAAGAGCTC
      Human     CCCCTATCATAGAAGAGCTT
    EOS

    system "#{bin}/raxmlHPC-SSE3", "-f", "a", "-m", "GTRGAMMA", "-p",
                                       "12345", "-x", "12345", "-N", "100",
                                       "-s", "aln.phy", "-n", "ts"
    assert_predicate testpath/"RAxML_bipartitions.ts", :exist?,
                     "Failed to create RAxML_bipartitions.ts"
  end
end
