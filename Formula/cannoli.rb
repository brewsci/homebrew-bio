class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark2_2.11/0.3.0/cannoli-distribution-spark2_2.11-0.3.0-bin.tar.gz"
  sha256 "8ecc77eacd85d27b7a47b2f9d5be80aa7e286a991cfc68b2512edbdcc7ce29ab"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "92b50cdf8c318b8ceab6c9719d84f5acb1c4ffd7b338ff0a6c923264d3357c4e" => :sierra
    sha256 "fcf69e2869fac7a034b917e694c046b9da596df78a0b8ce8b46681c78e0131a4" => :x86_64_linux
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
