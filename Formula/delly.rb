class Delly < Formula
  # cite Rausch_2012: "https://doi.org/10.1093/bioinformatics/bts378"
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "fbc6105489c8cefc94af662b3acbc8b7dd30b3c78a74d59da9982d416dcf584b"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "d93961ae45b709f332d428c7a9bd39469595ea6887a77a39daa8a78393752fce"
    sha256 cellar: :any, arm64_sequoia: "ea6d704be20edb0f8855e5a05ec95fe87833185bfc478363f8e5bbc58251401e"
    sha256 cellar: :any, arm64_sonoma:  "e9ac2db056026e410ccc82af2de62fe75399b06b2e1a73870ef6e243dc2a2db6"
    sha256 cellar: :any, x86_64_linux:  "67cf92b26aa5ed9906f21fbdd81e4c148e61375c6bb5dbf273418ae6d1b60168"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Build against Homebrew's htslib and boost instead of the bundled
    # submodules. Setting EBROOTHTSLIB to the Homebrew htslib prefix skips
    # the bundled htslib build, and the boost include/lib paths are added
    # explicitly so the linker finds the Homebrew boost libraries.
    ENV.append "CXXFLAGS", "-I#{formula_opt_include("boost")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("htslib")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("boost")}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{formula_opt_lib("boost")}"

    system "make", "PARALLEL=1", "EBROOTHTSLIB=#{formula_opt_include("htslib")}", "src/delly"
    bin.install "src/delly"
    prefix.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system "#{bin}/delly", "call", "-g", prefix/"example/ref.fa", "-o", testpath/"sr.bcf", prefix/"example/sr.bam"
    assert_path_exists testpath/"sr.bcf"
  end
end
