class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark2_2.11/0.7.0/cannoli-distribution-spark2_2.11-0.7.0-bin.tar.gz"
  sha256 "193d4a7919edf36747df2ca78efef601d0de0a1cf0ab9fb0c5062869cedcec29"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "1f27f8051beeeed0d9e3a4013b1e8f1f4357389b353dff1871222b19be2681ae" => :sierra
    sha256 "e6fbd8e759b1cfcfee556d81061c1b601e7b7efa8f2faac348776329e50886d2" => :x86_64_linux
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
