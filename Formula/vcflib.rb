class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    :tag => "v1.0.0-rc2", :revision => "5b0f4d5b0cbdfb7b890353b08b9d397c92312d8f"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "950e9b83f6d7510ecf7ba76c40a3f52f0688c5241789599c9c5f727b20c3c276" => :sierra_or_later
    sha256 "f66ab83f655287e179cd909013fe60a4e08099168297f9ee344bcb731409481e" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gcc" # https://github.com/ekg/tabixpp/issues/16
  else
    depends_on "bzip2"
    depends_on "perl"
    depends_on "zlib"
  end
  depends_on "python@2"
  depends_on "xz"

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
