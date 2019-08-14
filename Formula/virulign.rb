class Virulign < Formula
  # cite Libin_2018: "https://doi.org/10.1093/bioinformatics/bty851"
  desc "Fast codon-correct alignment and annotation of viral genomes"
  homepage "https://github.com/rega-cev/virulign"
  url "https://github.com/rega-cev/virulign/archive/v1.0.1.tar.gz"
  sha256 "f7191c31e73bced5b37a4ef2a1e6d0a5f4214598137588c4e2dc82bb52a0a74c"

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
