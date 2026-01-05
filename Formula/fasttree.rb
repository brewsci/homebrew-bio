class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.11.c"
  sha256 "9026ae550307374be92913d3098f8d44187d30bea07902b9dcbfb123eaa2050f"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "8db5f99ad593bd14f297135475ea3b3baed4c530b7e08eafaba18f92227e5f03"
    sha256 cellar: :any,                 arm64_sequoia: "e7b72181fb4a351615e30074f5cb9669e63f3f7ca9acb96c56916faf5bf96fd8"
    sha256 cellar: :any,                 arm64_sonoma:  "f414744118247ddc7f688f7b196d19d5e94419d3dbb7002b24a33e6b76a222e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181f75853b54820f3d25a17d0864d55dc9ff507de408ab86cdc89e0b03b78a6e"
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
