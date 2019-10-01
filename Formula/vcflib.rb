class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    :tag => "v1.0.1", :revision => "d150a89fa4f717634b06e1c78a37794d2c10c94c"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "0a7dd127083d4e4515cbd3ed38bd5cc5bdc693e0f1fd1bb3266bf0e17e04922d" => :sierra
    sha256 "f10f5737f8ecb6bf5ba530d10a86bb7576843c7e49f401c6018e660cf8027001" => :x86_64_linux
  end

  depends_on "gcc" if OS.mac?
  depends_on "python"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  fails_with :clang # error: ordered comparison between pointer and zero

  def install
    # Reduce memory usage for CircleCI
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "make"
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
