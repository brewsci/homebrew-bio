class Treepl < Formula
  # cite Smith_2012: "https://doi.org/10.1093/bioinformatics/bts492"
  desc "Dating phylogenies with penalized likelihood"
  homepage "https://github.com/blackrim/treePL/wiki"
  url "https://github.com/blackrim/treePL/archive/551cbde1a530adad7986c530ca1f254e3ffd42c7.tar.gz"
  version "2022.04.06"
  sha256 "8030f6da578a4ddd2aa3f24375ba15a8e39c06336eb31f900b80785511d4a46e"
  head "https://github.com/blackrim/treePL.git"

  livecheck do
    url "https://github.com/blackrim/treePL/commits"
    strategy :page_match
    regex(/datetime=.*?(\d{4}-\d{2}-\d{2})T/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 big_sur:      "fd7d35fb25cc1a9c3fdebd7dba0cf265b5dce2922dc940dd9928bfd527e2c25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0203b30c984251057539f869c0bba826ad3519ff4b1e16726ceb5172f302cf44"
  end

  depends_on "nlopt"

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.refurbish_args

    # Use the vendored copy of ADOL-C
    cd "deps" do
      system "tar", "xvf", "ADOL-C-2.6.3.tgz"
      cd "ADOL-C-2.6.3" do
        args = std_configure_args + %W[--prefix=#{libexec} --libdir=#{libexec}/lib --with-boost=no]
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
      args << "LDFLAGS=-L#{nlopt.lib} -L#{libexec}/lib #{"-Wl,-rpath,#{libexec}/lib" unless OS.mac?}"
      args << "OPENMP=-Xpreprocessor -fopenmp -lomp" if OS.mac?
      system "./configure", *std_configure_args
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
