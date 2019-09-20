class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.29.0/adam-distribution-spark2_2.11-0.29.0-bin.tar.gz"
  sha256 "2e5f9d4e63cf9263a5e9efd137e90c26fa88887be9c5715b48f793652192856c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "aa77cfc798dec6e26ea21626e2c6e9ab7e4a7aff7356a3008094e39a77634a8e" => :sierra
    sha256 "2c96a3aa6d447d10a1e8550f480f6d7c9e9533dfee94be790b75953f691d8b8a" => :x86_64_linux
  end

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
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
