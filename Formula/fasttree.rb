class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.11.c"
  sha256 "9026ae550307374be92913d3098f8d44187d30bea07902b9dcbfb123eaa2050f"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "2c89c53d229d845f69c2b14f5db56176a404b67c57a5e92d8748339bcf02b507"
    sha256 cellar: :any,                 ventura:      "f4997e05aee22777fa2c09963043936d3217e61179f413466410b0b01436ea55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8d0c50b4ff8f5fc3826c1bb388df78ff44e06ff64f76ab990fba58edad2c55a"
  end

  # 26 Aug 2017; Community mostly wants USE_DOUBLE; make it default now
  # http://www.microbesonline.org/fasttree/#BranchLen
  # http://darlinglab.org/blog/2015/03/23/not-so-fast-fasttree.html

  on_macos do
    depends_on "libomp"
  end

  def install
    opts = %w[
      -O3
      -finline-functions
      -funroll-loops
      -DOPENMP
      -DUSE_DOUBLE
    ]
    if OS.mac?
      opts << "-L#{Formula["libomp"].opt_lib}" << "-lomp"
    else
      opts << "-fopenmp"
    end
    system ENV.cc, "-o", "FastTree", "FastTree-#{version}.c", "-lm", *opts
    bin.install "FastTree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/FastTree -expert 2>&1")
    (testpath/"test.fa").write <<~EOS
      >1
      LCLYTHIGRNIYYGSYLYSETWNTTTMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >2
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV
      >3
      LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGTTLPWGQMSFWGATVITNLFSAIPYIGTNLV
    EOS
    assert_match(/1:0.\d+,2:0.\d+,3:0.\d+/, shell_output("#{bin}/FastTree test.fa 2>&1"))
  end
end
