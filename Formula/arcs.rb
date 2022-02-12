class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using linked or long reads"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.2.3/arcs-1.2.3.tar.gz"
  sha256 "191c863e4fb556bdbad20e8dfa675cb35e209b9198ab06bb8e7b948d9469a066"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "320d8b7397b75cbaeb3432f4ce1d887e411cb7c65d4930fa9eb120b69ce33ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3bd8cffcd05ac8c85e486b7c4f782c748de79df5d2feed438a82dc49cb25cf76"
  end

  head do
    url "https://github.com/bcgsc/arcs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
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
