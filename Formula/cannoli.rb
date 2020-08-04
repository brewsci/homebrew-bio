class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark3_2.12/0.10.0/cannoli-distribution-spark3_2.12-0.10.0-bin.tar.gz"
  sha256 "cf28fb95bbda7cccd5233d083ef5c05a7f943ec2f10244944287cb9b0ca57b42"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "85a5f347721f071b0b04122bb781f188fb595f260d14cac2bb00f6e4749dcd1e" => :catalina
    sha256 "dd93565b80fb944b9ecd016a4bf8e90373fc939cdf6d6f3db0df041c1f97a3f0" => :x86_64_linux
  end

  head do
    url "https://github.com/bigdatagenomics/cannoli.git", shallow: false
    depends_on "maven" => :build
  end

  depends_on "apache-spark"

  def install
    system "mvn", "clean", "install", "-DskipTests=true" if build.head?
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/cannoli-submit --help")
  end
end
