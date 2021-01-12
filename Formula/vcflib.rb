class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    tag:      "v1.0.2",
    revision: "da9929c00938b1d1b042e8ce42514211ef34875d"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "0a7dd127083d4e4515cbd3ed38bd5cc5bdc693e0f1fd1bb3266bf0e17e04922d" => :sierra
    sha256 "f10f5737f8ecb6bf5ba530d10a86bb7576843c7e49f401c6018e660cf8027001" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  depends_on "python"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "perl"
  uses_from_macos "zlib"
  
  resource "tabixpp" do
    url "https://github.com/ekg/tabixpp/archive/v1.1.0.tar.gz"
    sha256 "56c8f1b07190aba5e1d0b738e380e726d380f0ad8b2d0df133200b0ab1f8ed88"
  end

  def install
    (buildpath/"tabixpp").install resource("tabixpp")
    system "make", "CMAKE_FLAGS=-DCMAKE_CXX_FLAGS=-I#{buildpath}/tabixpp"
    pkgshare.install Dir["bin/*.R"]
    pkgshare.install Dir["bin/*.r"]
    rm Dir["bin/*.R"]
    rm Dir["bin/*.r"]
    bin.install Dir["bin/*"]
    bin.install "fastahack/fastahack"
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
