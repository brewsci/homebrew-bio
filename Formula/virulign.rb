class Virulign < Formula
  # cite Libin_2018: "https://doi.org/10.1093/bioinformatics/bty851"
  desc "Fast codon-correct alignment and annotation of viral genomes"
  homepage "https://github.com/rega-cev/virulign"
  url "https://github.com/rega-cev/virulign/archive/v1.0.1.tar.gz"
  sha256 "f7191c31e73bced5b37a4ef2a1e6d0a5f4214598137588c4e2dc82bb52a0a74c"

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
      # "make install" is still broken
      # https://github.com/rega-cev/virulign/issues/10
      bin.install "src/virulign"
    end
    pkgshare.install "references"
  end

  test do
    assert_match "Mutation", shell_output("#{bin}/virulign 2>&1")
  end
end
