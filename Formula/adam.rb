class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark3_2.12/0.32.0/adam-distribution-spark3_2.12-0.32.0-bin.tar.gz"
  sha256 "c8a556656c43131f31dfc70c15fca8533f665c5ebeb8450742ee945daa3c3660"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "907b6eae8a10b1c4502524fd3f23272971b8c073629e7e3ac52d028bfa3cb741" => :catalina
    sha256 "5beb6730a2c4320c3570ee993d27e4e8bf53091854869b9f7986c5d34007d119" => :x86_64_linux
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
