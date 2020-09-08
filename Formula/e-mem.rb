class EMem < Formula
  # cite Khiste_2015: "https://doi.org/10.1093/bioinformatics/btu687"
  desc "Efficiently compute MEMs between large genomes"
  homepage "https://www.csd.uwo.ca/~ilie/E-MEM/"
  url "https://github.com/lucian-ilie/E-MEM/archive/v1.0.1.tar.gz"
  sha256 "70a5a1e8b4e190d117b8629fff3493a4762708c8c0fe9eae84da918136ceafea"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "ff057c192242eb21d9392b1e616eaa579b301b90c608a49ce3a90e6d65015f79" => :catalina
    sha256 "badf5104b21d2f5d99031c6b65af178071b022d11c187f76b6ad2fe684b660bc" => :x86_64_linux
  end

  depends_on "boost" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    bin.mkpath
    system "make", "BIN_DIR=#{bin}"
    pkgshare.install "example"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/e-mem --help")
  end
end
