class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.26.0/adam-distribution-spark2_2.11-0.26.0-bin.tar.gz"
  sha256 "17a8a5021ef23db9beea9047d4dba8351bfe9d51f9b332708654fa647a60e64d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "58b2227b1b98fb8993e681ccde4763724829605756950bdd5fd3b3c399ec3ec2" => :sierra
    sha256 "0b7796be251094bb2575ed2caf8cb8cd5de527e3a72f943f068edb72fec5593f" => :x86_64_linux
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
