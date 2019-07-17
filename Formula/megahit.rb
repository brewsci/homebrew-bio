class Megahit < Formula
  # cite Li_2015: "https://doi.org/10.1093/bioinformatics/btv033"
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  url "https://github.com/voutcn/megahit/archive/v1.1.4.tar.gz"
  sha256 "ecd64c8bfa516ef6b19f9b2961ede281ec814db836f1a91953c213c944e1575f"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "44de1004f2014f3660a71d8a4bf1012440fb30e6d8bbc7e32cbbe9ce7af579e1" => :sierra
    sha256 "317e6684fbe9c566bfd94367461f752aa18745fcb81399068ac351d948bfbe94" => :x86_64_linux
  end

  depends_on "gcc@8" if OS.mac?
  depends_on "python@2"

  fails_with :gcc => "9"
  fails_with :clang # needs openmp

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install Dir["megahi*"]
    pkgshare.install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{pkgshare}/example/readsInterleaved1.fa.gz", "-o", outdir
    assert_predicate testpath/"#{outdir}/final.contigs.fa", :exist?
    assert_match outdir, File.read("#{outdir}/opts.txt")
  end
end
