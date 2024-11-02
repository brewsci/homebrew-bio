class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.11.c"
  sha256 "9026ae550307374be92913d3098f8d44187d30bea07902b9dcbfb123eaa2050f"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8657303011bfb1dc09b7301b70e4311d6da254fc2af121b0fb41b693ae846aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "2486324b394187f2b0ce9ee5474fabdae07c6ce32402ee64dffddbd60a86f642"
    sha256 cellar: :any,                 ventura:       "e6a699aa264b419e9225d1ebfe49a6dcc3c15840569a0e1a314b6a2f5b72dad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed6eccef2017b5f43c78354e94057d69ac828f34c0f7d7abad39803b93341921"
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
