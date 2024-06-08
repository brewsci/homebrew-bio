class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark3_2.12/1.0.1/adam-distribution-spark3_2.12-1.0.1-bin.tar.gz"
  sha256 "cd6259148a2d9d8bf10549cedd09fe5b12d9f34a25e80a4025f96d60e50be807"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/adam-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "2f9f402ac2f38f2ad4001f94359aa20976067abc668ab9d5fdb13f91315dd7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "178c1275208b80dc44056ec23af8775627167635f02bde7b8533e1bbe641cb17"
  end

  head do
    url "https://github.com/bigdatagenomics/adam.git", shallow: false
    depends_on "maven" => :build
  end

  depends_on "apache-spark"

  def install
    system "mvn", "clean", "install", "-DskipTests=true" if build.head?
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/adam-submit --help")
  end
end
