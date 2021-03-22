class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark3_2.12/0.12.0/cannoli-distribution-spark3_2.12-0.12.0-bin.tar.gz"
  sha256 "cebc4776aaf55cc9333716f3001d5f6c97cbe8be0faa260ad8b027246c71ae72"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/cannoli-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "716924507f69a2d5d0fa8b08e4b5434f78a3c99e70f8ef6fa0b3c1905569d23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d080c149240aa7b000cc4b1e047a3850f86b48caf751f32ff445ee9ee5cb55ff"
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
