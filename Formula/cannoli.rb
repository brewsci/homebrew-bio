class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark2_2.11/0.9.0/cannoli-distribution-spark2_2.11-0.9.0-bin.tar.gz"
  sha256 "b48d991c1d15960368dfc3b20ef1e02286361e3c0c6a9d2233dde488f7988fe5"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "e47e1dec48f1185fc47924d2555cee0ab117afe757c1dd90d0f04820aad5e828" => :catalina
    sha256 "36089d4444b6acdd2a1c67bdd22196828637e70dd930a450e535e04766807426" => :x86_64_linux
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
