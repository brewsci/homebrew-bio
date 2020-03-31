class Ntjoin < Formula
  # cite Coombe_2020: "https://doi.org/10.1101/2020.01.13.905240"
  desc "Genome assembly scaffolder using minimizer graphs"
  homepage "https://github.com/bcgsc/ntJoin"
  url "https://github.com/bcgsc/ntJoin/releases/download/v1.0.2/ntJoin-1.0.2.tar.gz"
  sha256 "ea95d7c3033a12a9698725e8144cdc3b75f9d7a2d165f5784e09e7b78d809023"
  head "https://github.com/bcgsc/ntJoin.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "b843446caa1c93a1585e3e3cf22772dfd8f5005f7d595a420bf9d2eef02d1b79" => :catalina
    sha256 "6f9e3ceacebcf8ba77d5723df304733a4f66e611458549a441187bc23748cca3" => :x86_64_linux
  end

  depends_on "bedtools"
  depends_on "gcc" if OS.mac? # needs openmp
  depends_on "numpy"
  depends_on "python"
  depends_on "samtools"
  depends_on "scipy"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    system "make", "-C", "src"
    ENV.prepend_path "PATH", libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    inreplace "requirements.txt", "python-igraph", "python-igraph==0.7.1.post6"
    system "pip3", "install", "--prefix=#{libexec}", "-r", "requirements.txt"
    bin.install "ntJoin"
    libexec_src = Pathname.new("#{libexec}/bin/src")
    libexec_src.install "src/indexlr"
    libexec_bin = Pathname.new("#{libexec}/bin/bin")
    libexec_bin.install Dir["bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => Dir[libexec/"lib/python*/site-packages"].first
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ntJoin help")
  end
end
