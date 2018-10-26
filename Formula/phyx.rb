class Phyx < Formula
  # cite Brown_2017: "https://doi.org/10.1093/bioinformatics/btx063"
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.999.tar.gz"
  sha256 "d8dfef84731677f92740fd6f0d003e0b3edc25b7e0eaa4c90c4d7da088f32a64"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b17d2d3f3270a7de8c63c6f2a22ab94d2cff06611d2fef933f9dc41fe55d01dd" => :sierra
    sha256 "f139fb3628527c5b8888e74e929be2c25b2c7945472488239ccd024e00f6c9f4" => :x86_64_linux
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
