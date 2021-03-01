class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark3_2.12/0.33.0/adam-distribution-spark3_2.12-0.33.0-bin.tar.gz"
  sha256 "e973c0136544659648669e1ebe29bab6c49863752dfa595722ff36d2647e054d"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/adam-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "ea041d65c96d402165dd140e5bdda5c304905fada259009e995679904cf9183a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5e8054a38850a7c7d181f62c35c40d146b98339e29e22f7e4e7633bc3203a61"
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
