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
    cellar :any_skip_relocation
    sha256 "6b2108bb284e51d0a73177f0435731faebaab4843babe1075e39f39044387e43" => :sierra
    sha256 "4deca3d89b7c58f3b8875154deef677b6c17847b33b118f2772292e62116356c" => :x86_64_linux
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
