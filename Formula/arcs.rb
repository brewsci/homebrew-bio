class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using linked or long reads"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.2.2/arcs-1.2.2.tar.gz"
  sha256 "9c3490eb77be198d28ca55eb10bae617f694f0abee0484d3f599e3354e97450b"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, catalina:     "20c0513d21d726a3cdf1d0016dc3072a7a2a78f34c6905373c1c2ccac9e9f736"
    sha256 cellar: :any, x86_64_linux: "38fdc0f3ab018cc03d4de8089df3ec7a3d02751d098b46f9d24bdd0fcb492a24"
  end

  head do
    url "https://github.com/bcgsc/arcs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "links-scaffolder"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    on_macos do
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
      ENV.append "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"
    end

    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
    libexec_src = Pathname.new("#{libexec}/bin/src")
    libexec_src.install "src/long-to-linked-pe"
    libexec_bin = Pathname.new("#{libexec}/bin/Examples")
    libexec_bin.install "Examples/makeTSVfile.py"
    libexec_bin.install "Examples/arcs-make"
    (bin/"arcs-make").write_env_script libexec/"bin/Examples/arcs-make", PYTHONPATH: ENV["PYTHONPATH"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arcs --help")
    assert_match "Usage", shell_output("#{bin}/long-to-linked-pe --help 2>&1")
    assert_match "Usage", shell_output("#{bin}/arcs-make help")
  end
end
