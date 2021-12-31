class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    tag: "v1.0.3", revision: "6ba0d27ff6ba8380f3d92fcfd07bd847a751d705"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "0a7dd127083d4e4515cbd3ed38bd5cc5bdc693e0f1fd1bb3266bf0e17e04922d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f10f5737f8ecb6bf5ba530d10a86bb7576843c7e49f401c6018e660cf8027001"
  end

  depends_on "cmake" => :build

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
