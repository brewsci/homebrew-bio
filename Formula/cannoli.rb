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
    sha256 cellar: :any_skip_relocation, catalina:     "23fe1316373ee3c3f0535f5828d9f3571769b2c4f81e18c59cc2c70065741783"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9fbdacbf448f1f67de4051206e6421914488f4ebb3ff275b38c16c678d705478"
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
