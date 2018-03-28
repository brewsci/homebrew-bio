class Adam < Formula
  # cite Nothaft_2015: "https://doi.org/10.1145/2723372.2742787"
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.24.0/adam-distribution-spark2_2.11-0.24.0-bin.tar.gz"
  sha256 "d272553dec2d5f25cea72b05ebf656db7be65b33657e351a0cf55543e2868277"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "c7f6a6d8ee7d73c255a17ba442f4c0d841e1e6eba3d6f72b84f81d2d1e8ae589" => :sierra_or_later
    sha256 "81364913e52d15dc450b214d17355c44c00d115b3349c475e0fe7c5f0b82c982" => :x86_64_linux
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
