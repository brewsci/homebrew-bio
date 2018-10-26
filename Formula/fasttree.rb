class Fasttree < Formula
  # cite Price_2010: "https://doi.org/10.1371/journal.pone.0009490"
  desc "Approximately-maximum-likelihood phylogenetic trees"
  homepage "http://microbesonline.org/fasttree/"
  url "http://microbesonline.org/fasttree/FastTree-2.1.10.c"
  sha256 "54cb89fc1728a974a59eae7a7ee6309cdd3cddda9a4c55b700a71219fc6e926d"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    rebuild 1
    sha256 "0cf193935cbc45bcfd494e0e15062a9de07870f0b6539f4ce35ccc0d565f5339" => :sierra
    sha256 "acf0c2e94f6bc3d0272a5bf36da9d5a3163591de07cb98ce32f99596306bb03e" => :x86_64_linux
  end

  # 26 Aug 2017; Community mostly wants USE_DOUBLE; make it default now
  # http://www.microbesonline.org/fasttree/#BranchLen
  # http://darlinglab.org/blog/2015/03/23/not-so-fast-fasttree.html

  option "without-double", "Disable double precision floating point. Use single precision floating point and enable SSE."
  option "without-openmp", "Disable multithreading support"
  option "without-sse", "Disable SSE parallel instructions"

  fails_with :clang # needs OpenMP

  depends_on "gcc" if OS.mac? # needs OpenMP

  def install
    opts = %w[-O3 -finline-functions -funroll-loops]
    opts << "-DOPENMP" << "-fopenmp" if build.with? "openmp"
    opts << "-DUSE_DOUBLE" if build.with? "double"
    opts << "-DNO_SSE" if build.without? "sse"
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
