class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark3_2.12/0.37.0/adam-distribution-spark3_2.12-0.37.0-bin.tar.gz"
  sha256 "98800f24a154bd04fe19e7a8aa6c3f875005c5ff49b86b31d57c9cad75bec648"

  livecheck do
    url :homepage
    strategy :github_latest
    regex(%r{href=.*?/tag/adam-parent-spark\d+[_-]\d+(?:\.\d+)+[_-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "cd1d89e3987bcf26e4ebfbb90f1b5c8f96c74260f2909fae335effdc38cf1b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d78427a2817fbc0e4014d4d203cc5d410158a19ad13154f21001d6d83acd4953"
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
