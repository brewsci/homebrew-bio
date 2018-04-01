class Raxml < Formula
  # cite Stamatakis_2014: "https://doi.org/10.1093/bioinformatics/btu033"
  desc "Maximum likelihood analysis of large phylogenies"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.11.tar.gz"
  sha256 "08cda74bf61b90eb09c229e39b1121c6d95caf182708e8745bd69d02848574d7"
  head "https://github.com/stamatak/standard-RAxML.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b05330863e74c37db0f647ea7922008e2eb5fc564485b9f2c531ca8b289efabc" => :sierra_or_later
    sha256 "86d4b421265183d8fcf76b9c525ac62f9d12e1106ed6e1b02491c5bf199c859b" => :x86_64_linux
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
