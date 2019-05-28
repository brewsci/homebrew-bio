class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.27.0/adam-distribution-spark2_2.11-0.27.0-bin.tar.gz"
  sha256 "9efa010fd8c06998217f93e1f620c0e11f373260b00d589cadb1e48354210e7c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "2a4dcda80b0cc137a2c432016f864e5551b8d514cf079395410d5bc08c3cac31" => :sierra
    sha256 "6c4fb4bbed3d317d82909217c8ac7355ba0d91f109815a69c9c0ce98a2d4d71c" => :x86_64_linux
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
