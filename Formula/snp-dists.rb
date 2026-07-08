class SnpDists < Formula
  desc "Pairwise SNP distance matrix from a FASTA sequence alignment"
  homepage "https://github.com/tseemann/snp-dists"
  url "https://github.com/tseemann/snp-dists/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "a786ee22e9744b421561bfa4dbac9f3149abca05edd5d48797566c25feea9bdc"
  license "GPL-3.0"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "289caa0d1b0ae5d8baa1e3b9f3a16e367d6ffdfb41b3b3099da18f61cf84653e"
    sha256 cellar: :any, arm64_sequoia: "4db720871373e1eb5c42bb9451ff22c3c3575284696aa83ea0ad3f0f4498c264"
    sha256 cellar: :any, arm64_sonoma:  "6b970e646cb06859a8597feaf386bbe3ab68a4f5db06ff04bd8df44aa77ce727"
    sha256 cellar: :any, x86_64_linux:  "6bea1394624186d515bdc90d0f125567dd65478fa331c9a6ae50b08568a99df3"
  end

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
