class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.11.c"
  sha256 "9026ae550307374be92913d3098f8d44187d30bea07902b9dcbfb123eaa2050f"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "00e170051838803db512a523803daf59f01144a126ad5f5eafd7d80bc42bb0cf" => :catalina
    sha256 "304bf00600d673074d03a03411e05ca9706bf8ca5b3b894831995a9a5cb9f98b" => :x86_64_linux
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
    assert_match /1:0.\d+,2:0.\d+,3:0.\d+/, shell_output("#{bin}/FastTree test.fa 2>&1")
  end
end
