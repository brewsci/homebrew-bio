class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark3_2.12/0.15.0/cannoli-distribution-spark3_2.12-0.15.0-bin.tar.gz"
  sha256 "a92cdedc72066e8e022bbe6a6aaf092bd24fa25c839212a34f5a1371f9744a78"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/cannoli-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2fc56aaf33a0603f81e264a19ddf2cb5e46b6e21b2779b65c2d4929491d1d7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a001cf63e829cbb5abc956d6f50ca7fc4203c4e2e0dfeb17e1e926c20817410d"
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
