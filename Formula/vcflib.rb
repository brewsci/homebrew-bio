class Vcflib < Formula
  desc "Command-line tools for manipulating VCF files"
  homepage "https://github.com/ekg/vcflib"
  url "https://github.com/ekg/vcflib.git",
    :tag => "v1.0.0-rc1", :revision => "3e03c7a10098b3888aaa258d4e339ddcdbf3b951"
  head "https://github.com/ekg/vcflib.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "950e9b83f6d7510ecf7ba76c40a3f52f0688c5241789599c9c5f727b20c3c276" => :sierra_or_later
    sha256 "f66ab83f655287e179cd909013fe60a4e08099168297f9ee344bcb731409481e" => :x86_64_linux
  end

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
