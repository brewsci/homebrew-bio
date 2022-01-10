class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark3_2.12/0.14.0/cannoli-distribution-spark3_2.12-0.14.0-bin.tar.gz"
  sha256 "c64b0b1c47b5d996ed99f95e92f289d7268256da9f49079c88b10d21d0a4b5ad"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/cannoli-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "d0f6989b04baa1e448b0d00dbc2f58cbfd83221a46f5a6cbd565e69bcce51fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c9f1365ba64bd0262c83cbac578b50697f6ec0ed4d036e3e5443eeb54ee3273a"
  end

  head do
    url "https://github.com/bigdatagenomics/cannoli.git", shallow: false
    depends_on "maven" => :build
  end

  depends_on "apache-spark"

  def install
    system "mvn", "clean", "install", "-DskipTests=true" if build.head?
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cannoli-submit --help")
  end
end
