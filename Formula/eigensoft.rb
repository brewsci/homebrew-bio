class Eigensoft < Formula
  # cite Patterson_2006: "https://doi.org/10.1371/journal.pgen.0020190"
  # cite Price_2006: "https://doi.org/10.1038/ng1847"
  desc "Eigen tools by Nick Patterson and Alkes Price lab"
  homepage "https://github.com/DReichLab/EIG"
  url "https://github.com/DReichLab/EIG/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "e3459e8ac0134da369910454854eae5c7b261e8816318ccbd2d371b4c6c35741"
  head "https://github.com/DReichLab/EIG.git", branch: "master"

  depends_on "gsl"
  depends_on "openblas"

  uses_from_macos "perl"

  patch do
    # https://github.com/DReichLab/EIG/pull/97
    url "https://github.com/DReichLab/EIG/commit/7201ea72b362cf79ed6c88456df0ed5c3590ef87.patch?full_index=1"
    sha256 "354eaaf42d0b1d4ed8ddb8c2c00972f8f038cbce952368c10a17bec7e52c405a"
  end

  patch do
    # https://github.com/DReichLab/EIG/pull/97
    url "https://github.com/DReichLab/EIG/commit/a986aad388ade4709d973f647d11fc561edd1f44.patch?full_index=1"
    sha256 "148648575fc5bdcfb3f02c90c9e6a8d1ccbed51d6519ad88573b277215b1340d"
  end

  patch do
    # https://github.com/DReichLab/EIG/pull/90
    url "https://github.com/DReichLab/EIG/commit/a5cd7af6560c14b9fea632ff61352ee30c879cff.patch?full_index=1"
    sha256 "94eec6ddb62cc23b1552ab9ea055036f70dee06feb2e0a69dbaa49a7169746ee"
  end

  def samples
    pkgshare/"samples"
  end

  def install
    cd "src" do
      system "make", "install"
    end

    samples.install "CONVERTF"
    samples.install "EIGENSTRAT"
    samples.install "POPGEN"

    pkgshare.install Dir["bin/*.perl"]
    bin.install Dir["bin/*"]
  end

  def caveats
    "To generate figures, run `brew install gnuplot`."
  end

  test do
    ENV.prepend_path "PATH", bin

    cp_r samples/"CONVERTF", testpath
    cd "CONVERTF" do
      assert_match(/^##end of convertf run$/, shell_output("#{bin}/convertf -p par.EIGENSTRAT.PED"))
      assert_match(Regexp.new(<<~EOS), File.read("example.pedind"))
        \s+1\s+SAMPLE0 0 0 2 2
        \s+2\s+SAMPLE1 0 0 1 2
        \s+3\s+SAMPLE2 0 0 2 1
        \s+4\s+SAMPLE3 0 0 1 1
        \s+5\s+SAMPLE4 0 0 2 1
      EOS
    end

    cp_r samples/"EIGENSTRAT", testpath
    cd "EIGENSTRAT" do
      assert_match(/^gc.perl example.chisq example.chisq.GC$/, shell_output("perl example.perl"))
      assert_predicate Pathname.pwd/"example.pca", :exist?
      assert_predicate Pathname.pwd/"example.pca.evec", :exist?
      assert_predicate Pathname.pwd/"example.plot.pdf", :exist?
      assert_predicate Pathname.pwd/"example.plot.ps", :exist?
      assert_predicate Pathname.pwd/"example.plot.xtxt", :exist?
    end

    cp_r samples/"POPGEN", testpath
    cd "POPGEN" do
      assert_match(/^evec2pca.perl 2 example.evec example.ind example.pca$/, shell_output("perl example.perl"))
      assert_predicate Pathname.pwd/"example.pca", :exist?
      assert_predicate Pathname.pwd/"example.evec", :exist?
      assert_predicate Pathname.pwd/"example.plot.pdf", :exist?
      assert_predicate Pathname.pwd/"example.plot.ps", :exist?
      assert_predicate Pathname.pwd/"example.plot.xtxt", :exist?
    end
  end
end
