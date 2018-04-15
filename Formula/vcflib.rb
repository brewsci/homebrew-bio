class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    :tag => "v1.0.0-rc1", :revision => "3e03c7a10098b3888aaa258d4e339ddcdbf3b951"
  head "https://github.com/ekg/vcflib.git"

  if OS.mac?
    depends_on "gcc" # https://github.com/ekg/tabixpp/issues/16
  else
    depends_on "zlib"
  end

  fails_with :clang # error: ordered comparison between pointer and zero

  def install
    # Reduce memory usage for CircleCI
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    system "make"
    rm Dir["bin/*.R"]

    bin.install Dir["bin/*"]
    doc.install %w[LICENSE README.md]
  end

  test do
    assert_match "genotype", shell_output("#{bin}/vcfallelicprimitives -h 2>&1")
  end
end
