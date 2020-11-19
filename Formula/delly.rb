class Delly < Formula
  # cite Rausch_2012: "https://doi.org/10.1093/bioinformatics/bts378"
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly.git",
      tag:      "v0.8.5",
      revision: "0881a99c06b579586f6350f27bf85fe2a1e20ff6"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "cef13a263a84ec23a8708f909345c1cdbfa000135d9c21dc0a00b45d91f1aed6" => :catalina
    sha256 "9453aaa771a707a430ac9f82a41ef086df4572b55244fa1a0a9d2471c6db52b5" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "boost"
  depends_on "htslib"
  depends_on "libomp" if OS.mac?
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    boost = Formula["boost"]
    ENV.append_to_cflags "-L#{boost.lib} -I#{boost.include}"
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?
    system "make", "PARALLEL=1", "src/delly"
    bin.install "src/delly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
  end
end
