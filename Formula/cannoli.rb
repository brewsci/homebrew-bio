class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark2_2.11/0.9.0/cannoli-distribution-spark2_2.11-0.9.0-bin.tar.gz"
  sha256 "b48d991c1d15960368dfc3b20ef1e02286361e3c0c6a9d2233dde488f7988fe5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "b04aa87fe838b097d346fb54d1bf38a2d64c922f1a88e17a57bac1157f734b85" => :mojave
    sha256 "0c805989de8a38f9150a8bb79f6d67edf4e455441dc9a3a4f0b8eb957f65e7bd" => :x86_64_linux
  end

  head do
    url "https://github.com/bigdatagenomics/cannoli.git", :shallow => false
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
