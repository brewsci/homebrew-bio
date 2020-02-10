class Treepl < Formula
  # cite Smith_2012: "https://doi.org/10.1093/bioinformatics/bts492"
  desc "Dating phylogenies with penalized likelihood"
  homepage "https://github.com/blackrim/treePL/wiki"
  url "https://github.com/blackrim/treePL/archive/87d432a08a00b918a9d7658edc813baa1f93723a.tar.gz"
  version "2018.05.22"
  sha256 "a974497f3abfbc4d6671f0bf5ea2001ad09c03ccc8d9d3d77bb800269241c59c"
  head "https://github.com/blackrim/treePL.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "e62bff49272a105c8b9d0157f4b59953821c5d8556eb6ed231d4860c08554565" => :catalina
    sha256 "78fddd7315e9747af2b3b9510a03154e6a0008dbd90df60e6d3d1ebf36dcb8ba" => :x86_64_linux
  end

  depends_on "libomp" if OS.mac?
  depends_on "nlopt"

  def install
    ENV.refurbish_args

    # Use the vendored copy of ADOL-C
    cd "deps" do
      system "tar", "xvf", "ADOL-C-2.6.3.tgz"
      cd "ADOL-C-2.6.3" do
        args = %W[--prefix=#{libexec} --disable-silent-rules --disable-dependency-tracking]
        args << "--with-openmp-flag=#{OS.mac? ? "-Xpreprocessor -fopenmp -lomp" : "-fopenmp"}"
        system "./configure", *args
        system "make", "install"
      end
    end

    cd "src" do
      # Tell configure where to find libraries. The ordering is very strict
      nlopt = Formula["nlopt"]
      args = %W[CPPFLAGS=-I#{libexec}/include CFLAGS=-I#{nlopt.include}]
      # don't use RPATH on macOS
      args << "LDFLAGS=-L#{nlopt.lib} -L#{libexec}/lib64 #{"-Wl,-rpath,#{libexec}/lib64" unless OS.mac?}"
      args << "OPENMP=-Xpreprocessor -fopenmp -lomp" if OS.mac?

      system "./configure"
      system "make", *args
      bin.install "treePL"
    end

    pkgshare.install "examples"
  end

  test do
    cp_r opt_pkgshare/"examples", testpath
    cd testpath/"examples" do
      system "#{bin}/treePL", "clock.cppr8s"
      system "#{bin}/treePL", "test.cppr8s"
    end
  end
end
