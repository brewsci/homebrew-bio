class Cannoli < Formula
  desc "Big Data Genomics ADAM Pipe API wrappers for bioinformatics tools"
  homepage "https://github.com/bigdatagenomics/cannoli"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/cannoli/cannoli-distribution-spark2_2.11/0.7.0/cannoli-distribution-spark2_2.11-0.7.0-bin.tar.gz"
  sha256 "193d4a7919edf36747df2ca78efef601d0de0a1cf0ab9fb0c5062869cedcec29"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3cd2c785579e5ba45ea7111d2c4409089a3090162d5b6bedeae4b63b4d163afb" => :sierra
    sha256 "b5a5595141e5d8469d6bd2cd6b6f97a2224389c18d3058378e83c346305d77ed" => :x86_64_linux
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
