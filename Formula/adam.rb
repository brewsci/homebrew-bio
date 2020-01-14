class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.30.0/adam-distribution-spark2_2.11-0.30.0-bin.tar.gz"
  sha256 "2a2bad76ee89beeea2162265c0144a2749d66645a4db80b20b761e01a822f861"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e17eae45abcfc7cc75e784c33d488d5251d58259437aefc89b156c35f88be492" => :mojave
    sha256 "157467bfd7794832da9c3eb0e5a6b2fdc2100379e8e0f2687077973045e25176" => :x86_64_linux
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
