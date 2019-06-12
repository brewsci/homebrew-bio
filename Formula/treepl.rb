class Treepl < Formula
  # cite Smith_2012: "https://doi.org/10.1093/bioinformatics/bts492"
  desc "Dating phylogenies with penalized likelihood"
  homepage "https://github.com/blackrim/treePL/wiki"
  url "https://github.com/blackrim/treePL/archive/fcddad99f4ecbada67ecd210f12fefa762f0d51c.tar.gz"
  version "2017.05.23"
  sha256 "7543dbf3cc174bc4b7a39618267439c11c9cd5d1f18ef5b42f0159f389684370"
  revision 2
  head "https://github.com/blackrim/treePL.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6b2108bb284e51d0a73177f0435731faebaab4843babe1075e39f39044387e43" => :sierra
    sha256 "4deca3d89b7c58f3b8875154deef677b6c17847b33b118f2772292e62116356c" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" if OS.mac? # needs OpenMP support
  depends_on "nlopt"

  fails_with :clang # needs OpenMP support

  def install
    ENV.refurbish_args

    # Use the vendored copy of ADOL-C
    cd "deps" do
      system "tar", "xvf", "adol-c_git_saved.tar.gz"
      cd "adol-c" do
        system "autoreconf", "-fvi"
        system "./configure", "--with-openmp-flag=-fopenmp", "--prefix=#{libexec}"
        system "make", "install"
      end
    end

    cd "src" do
      # Tell configure where to find libraries. The ordering is very strict
      nlopt = Formula["nlopt"]
      ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
      ENV.append_to_cflags "-I#{nlopt.include}"
      ENV.append "LDFLAGS", "-L#{nlopt.lib}"
      ENV.prepend "LDFLAGS", "-L#{libexec}/lib64"
      ENV.prepend "LDFLAGS", "-Wl,-rpath,#{libexec}/lib64" unless OS.mac? # don't use RPATH on macOS

      system "./configure"
      system "make"
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
