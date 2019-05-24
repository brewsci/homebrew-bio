class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.999.tar.gz"
  sha256 "d8dfef84731677f92740fd6f0d003e0b3edc25b7e0eaa4c90c4d7da088f32a64"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "0624af0f10604c04808ffb83aa89f247fb247e9b328591603ec85710166f7592" => :sierra
    sha256 "df83058b0a1ac9893fed65f50663ce15a95d01f79614b2d2d3e0071748be8e15" => :x86_64_linux
  end

  depends_on "armadillo"
  depends_on "nlopt"

  def install
    cd "src" do
      if OS.linux?
        inreplace "Makefile.in" do |s|
          # When bottling, disable opportunistic linking to libmvec,
          # which causes runtime errors on glibc > 2.19 and < 2.22
          s.gsub! "-ftree-vectorize", "-fno-tree-vectorize" if ENV["CIRCLECI"]
        end
      end
      system "./configure", "--prefix=#{prefix}"
      system "make"
      bin.mkdir
      system "make", "install"
    end
    pkgshare.install Dir["example_files/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pxseqgen --help")
    # This test times out for unknown reasons on CircleCI with Linux.
    unless ENV["CIRCLECI"] && OS.linux?
      system "#{bin}/pxseqgen", "-t", "#{pkgshare}/pxseqgen_example/seqgen_test.tre", "-o", "output.fa"
      File.exist? "output.fa"
    end
  end
end
