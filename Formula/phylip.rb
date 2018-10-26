class Phylip < Formula
  # cite "https://doi.org/10.1007/BF01734359"
  desc "Package of programs for inferring phylogenies"
  homepage "http://evolution.genetics.washington.edu/phylip.html"
  url "http://evolution.gs.washington.edu/phylip/download/phylip-3.697.tar.gz"
  sha256 "9a26d8b08b8afea7f708509ef41df484003101eaf4beceb5cf7851eb940510c1"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "408a84406e51f2306176eaa97865e6737f270300a12825d50b3f34ee15102679" => :sierra
    sha256 "bbadb5138e4d3bb0824497d97996252a5e266dd99cb95a87551061c57392a518" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make", "-f", "Makefile.unx", "all"
      system "make", "-f", "Makefile.unx", "put", "EXEDIR=#{libexec}"
    end

    rm Dir["#{libexec}/font*"]
    bin.install_symlink Dir["#{libexec}/*"] - Dir["#{libexec}/*.{so,jar,unx}"]
    pkgshare.install ["phylip.html", "doc"]
  end

  test do
    # From http://evolution.genetics.washington.edu/phylip/doc/pars.html
    (testpath/"infile").write <<~EOS
      7         6
      Alpha1    110110
      Alpha2    110110
      Beta1     110000
      Beta2     110000
      Gamma1    100110
      Delta     001001
      Epsilon   001110
    EOS
    expected = "(((Epsilon:0.00,Delta:3.00):2.00,Gamma1:0.00):1.00,(Beta2:0.00,Beta1:0.00):2.00,Alpha2:0.00,Alpha1:0.00);"
    system "echo 'Y' | #{bin}/pars"
    assert_match expected, File.read("outtree")
  end
end
