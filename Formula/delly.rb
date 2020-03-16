class Delly < Formula
  # cite Rausch_2012: "https://doi.org/10.1093/bioinformatics/bts378"
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly.git",
      :tag      => "v0.8.3",
      :revision => "56ab2900da269568dc327045913ae77ff3919df1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "58c163c66ccc974146287df238ddbfb073c54486636ab12578b57997710b5347" => :catalina
    sha256 "6f65366a9da00ccad5206d0bb5c13ee6a7d304cde81db49609b31ab51dcae13b" => :x86_64_linux
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
