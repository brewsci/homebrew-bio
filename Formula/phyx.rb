class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.99.tar.gz"
  sha256 "6c767b2b2a9666849c3035e479a2135734fccf882d4957f69ea251632d7ed010"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "d9821ebe34bc7d7e4a841854134755dbf047487e762841249ae0a07834068292" => :sierra_or_later
    sha256 "116c5e248f4d2043340e60b88c6a10291ec8ef84ffb9b0d5647f0d288ddb179f" => :x86_64_linux
  end

  depends_on "armadillo"
  depends_on "nlopt"

  def install
    cd "src" do
      if OS.linux?
        inreplace "Makefile.in" do |s|
          # configure doesn't detect NLopt properly. fixed in > 0.99
          s.gsub! "@HNLOPT@", "Y"
          # When bottling, disable opportunistic linking to libmvec,
          # which causes runtime errors on glibc > 2.19 and < 2.22
          s.gsub! "-ftree-vectorize", "-fno-tree-vectorize" if ENV["CIRCLECI"]
        end
      end
      system "./configure", "--prefix=#{prefix}"
      system "make"
      # Makefile installs directly to prefix. fixed in > 0.99
      bin.install Dir["px*"]
    end
    pkgshare.install Dir["example_files/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pxseqgen --help")
    # This test times out for unknown reasons on CircleCI with Linux.
    return if ENV["CIRCLECI"] && OS.linux?
    system "#{bin}/pxseqgen", "-t", "#{pkgshare}/pxseqgen_example/seqgen_test.tre", "-o", "output.fa"
    File.exist? "output.fa"
  end
end
