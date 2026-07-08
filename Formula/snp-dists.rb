class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a786ee22e9744b421561bfa4dbac9f3149abca05edd5d48797566c25feea9bdc"
  license "GPL-3.0"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    inreplace "Makefile" do |s|
      if OS.mac?
        # Apple Clang needs -Xpreprocessor -fopenmp plus explicit libomp
        # include/library paths and -lomp to link the OpenMP runtime.
        libomp = Formula["libomp"]
        s.gsub! "CFLAGS = -Wall -Wextra -Ofast -std=c99 -fopenmp",
                "CFLAGS += -Wall -Wextra -Ofast -std=c99 " \
                "-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
        s.gsub! "LIBS = -lz -lm",
                "LIBS += -lz -lm -L#{libomp.opt_lib} -lomp"
      else
        s.gsub! "CFLAGS = -Wall -Wextra -Ofast -std=c99 -fopenmp",
                "CFLAGS += -Wall -Wextra -Ofast -std=c99 -fopenmp"
        s.gsub! "LIBS = -lz -lm",
                "LIBS += -lz -lm"
      end
    end
    system "make"
    system "make", "check"
    bin.install "snp-dists"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snp-dists -v")
    assert_match "matrix", shell_output("#{bin}/snp-dists -h")
    assert_match ",seq1,seq2,seq3,seq4", shell_output("#{bin}/snp-dists -q -b -c #{pkgshare}/test/good.aln")
  end
end
