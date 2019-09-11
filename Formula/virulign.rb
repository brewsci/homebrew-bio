class Virulign < Formula
  # cite Libin_2018: "https://doi.org/10.1093/bioinformatics/bty851"
  desc "Fast codon-correct alignment and annotation of viral genomes"
  homepage "https://github.com/rega-cev/virulign"
  url "https://github.com/rega-cev/virulign/archive/v1.0.2.tar.gz"
  sha256 "3e6934d5b5f37ff60b3aed94472b8076a6e79ea870f7e0ad5c4208a4d13d3c09"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0d4f449f8c8777390a014d11f90900cde48d1932af55457ca83c01ddd8692a8" => :sierra
    sha256 "c3a6c7aeddd98e5b8346534a1650e46ed4c5f72416f82cda23cc07e16358120a" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "references"
  end

  test do
    assert_match "Mutation", shell_output("#{bin}/virulign 2>&1")
  end
end
