class EMem < Formula
  # cite Khiste_2015: "https://doi.org/10.1093/bioinformatics/btu687"
  desc "Efficiently compute MEMs between large genomes"
  homepage "https://www.csd.uwo.ca/~ilie/E-MEM/"
  url "https://github.com/lucian-ilie/E-MEM/archive/v1.0.1.tar.gz"
  sha256 "70a5a1e8b4e190d117b8629fff3493a4762708c8c0fe9eae84da918136ceafea"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "3c9a845ba5cae921c0fce986c5245e5fc58583c294ca75190afccbaf80bce58f" => :sierra
    sha256 "76369dd5a7d236a62f5b64c69a9f171b7db2c2f5a6e090a253e266e6d920df04" => :x86_64_linux
  end

  fails_with :clang # needs openmp

  depends_on "boost" => :build
  depends_on "gcc" if OS.mac? # for openmp

  def install
    bin.mkpath
    system "make", "BIN_DIR=#{bin}"
    pkgshare.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/e-mem --help")
  end
end
