class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    tag: "v1.0.3", revision: "6ba0d27ff6ba8380f3d92fcfd07bd847a751d705"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "b5cb4439fd442391b5339b3cf5ae3cca87edd3443a5e28a0708c7a9dbc91e1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "47f04c252cb344b3debdfdf8b65e0db0a086d18f4f3437514078579b48251000"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "htslib"
  depends_on "python"
  depends_on "tabixpp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DHTSLIB_LOCAL:BOOL=FALSE"
      system "make"
      system "make", "install"
    end

    pkgshare.install Dir["scripts/*.R"]
    pkgshare.install Dir["scripts/*.r"]
    rm Dir["scripts/*.R"]
    rm Dir["scripts/*.r"]
    bin.install Dir["scripts/*"]

    mv prefix/"man", share
    pkgshare.install "samples"
  end

  def caveats
    <<~EOS
      The vcflib R scripts can be found in
      #{HOMEBREW_PREFIX}/share/vcflib/
    EOS
  end

  test do
    assert_match "genotype", shell_output("#{bin}/vcfallelicprimitives -h 2>&1")
    assert_match "biallelic snps:\t6", shell_output("#{bin}/vcfstats #{pkgshare}/samples/sample.vcf 2>&1")
    assert_match "chr\t0\t1\t.", shell_output("echo 'chr 1 . T' | #{bin}/vcf2bed.py")
    assert_match "genotypes", shell_output("#{bin}/vcfgtcompare.sh 2>&1")
    system "#{bin}/vcffirstheader < /dev/null"
  end
end
