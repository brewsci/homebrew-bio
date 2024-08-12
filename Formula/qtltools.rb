class Qtltools < Formula
  # cite Delaneau_2017: "https://doi.org/10.1038/ncomms15452"
  # cite Ongen_2017: "https://doi.org/10.1038/ng.3981"
  # cite Fort_2017: "https://doi.org/10.1093/bioinformatics/btx074"
  desc "Complete tool set for molecular QTL discovery and analysis"
  homepage "https://qtltools.github.io/qtltools/"
  url "https://github.com/qtltools/qtltools/archive/refs/tags/1.3.1.tar.gz"
  sha256 "033b9b61923fd65c4b8b80bc0add321e6fd6fb40de49d15c2dfe6a4d7e60764a"
  license "GPL-3.0-or-later"
  head "https://github.com/qtltools/qtltools.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "27740360672580eec33f8a9aec36b81b9a32b388591401dfe4b6e3d75d86a963"
    sha256 cellar: :any,                 ventura:      "1e3f78aced892bc56bc070b2e1e1f5059fee9e4f437efe693a06e22f2e974995"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2964bbbb7725debe3a9634a8bb946ced582f5715e027d59365b37d87950344b9"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gsl"
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "r"
  depends_on "xz" # for lzma

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "prefix      = /usr/local", "prefix = #{prefix}"
      s.gsub! "autocompdir = /usr/local/etc/bash_completion.d", "autocompdir = #{prefix}/etc/bash_completion.d"
      s.gsub! "autocompdir = /etc/bash_completion.d", "autocompdir = #{prefix}/etc/bash_completion.d"
    end
    args = [
      "BOOST_INC=#{Formula["boost"].opt_include}",
      "BOOST_LIB=#{Formula["boost"].opt_lib}",
      "RMATH_INC=#{Formula["r"].opt_include}",
      "RMATH_LIB=#{Formula["r"].opt_lib}",
      "HTSLD_INC=#{Formula["htslib"].opt_include}",
      "HTSLD_LIB=#{Formula["htslib"].opt_lib}",
      "LIB_FLAGS=-lz -lgsl -lbz2 -llzma -lgslcblas -lm -lpthread -lcurl -lhts -ldeflate -lssl -lcrypto",
    ]
    system "make", *args
    system "make", "install"
  end

  test do
    resource "testdata" do
      url "https://github.com/qtltools/qtltools/raw/master/example_files/genes.50percent.chr22.bed.gz"
      sha256 "fc50a0750194971d18ba28ac69f787ba10c26bd03eb204ef1cd88b3d22b28d7d"
    end
    resource "testdata_index" do
      url "https://github.com/qtltools/qtltools/raw/master/example_files/genes.50percent.chr22.bed.gz.tbi"
      sha256 "dbbde52b174e6e702142aa2b7118e161ba48b11f2d2f3ef7a87307203e6d4602"
    end
    resource("testdata").fetch
    cp resource("testdata").cached_download, testpath/"genes.50percent.chr22.bed.gz"
    resource("testdata_index").fetch
    cp resource("testdata_index").cached_download, testpath/"genes.50percent.chr22.bed.gz.tbi"
    system "#{bin}/QTLtools", "pca", "--bed", "genes.50percent.chr22.bed.gz", "--scale",
          "--center", "--out", "genes.50percent.chr22"
    assert_predicate testpath/"genes.50percent.chr22.pca_stats", :exist?
    assert_match "prop_var", File.read("genes.50percent.chr22.pca_stats")
  end
end
