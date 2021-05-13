class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark3_2.12/0.35.0/adam-distribution-spark3_2.12-0.35.0-bin.tar.gz"
  sha256 "26de0c559e43688d3c13ef336fa513c8a84b4d259abe7938b91292d42e5a6efa"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/adam-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "f6d0f054e4c33368eda8f39b60b777fd0a5dc6df585b4e138edf08f5f072c86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac202dac08582fc68079230223d39839e9588f5d8292dafc7da2e3ac2f8e7eb1"
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
