class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using linked or long reads"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "6ddb0afe2df3f34bed14c4d51bdb3d504ea34a76a10b6d82848823648e58ae3f"
  license "GPL-3.0-only"
  head "https://github.com/bcgsc/arcs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "320d8b7397b75cbaeb3432f4ce1d887e411cb7c65d4930fa9eb120b69ce33ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3bd8cffcd05ac8c85e486b7c4f782c748de79df5d2feed438a82dc49cb25cf76"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "libtool" => :build
  depends_on "abyss"
  depends_on "brewsci/bio/btllib"
  depends_on "brewsci/bio/links-scaffolder"
  depends_on "minimap2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
      ENV.append "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"
    end

    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
    inreplace "bin/arcs-make",
              "$(bin)/../src/long-to-linked-pe",
              "$(bin)/long-to-linked-pe"
    inreplace "bin/arcs-make", "python $(bin)", "python3 $(bin)"
    bin.install "bin/arcs-make"
    inreplace "bin/makeTSVfile.py", "#!/usr/bin/env python", "#!/usr/bin/env python3"
    bin.install "bin/makeTSVfile.py"
    libexec.install "src/long-to-linked-pe"
    bin.install_symlink libexec/"long-to-linked-pe"
    prefix.install "Examples"
  end

  test do
    resource "test_scaffolds" do
      url "https://raw.githubusercontent.com/bcgsc/arcs/master/Examples/arcs-long_test-demo/test_scaffolds.fa"
      sha256 "772b377c325f39c71ea0c436cf3c83f17693b9468b330c79e012a0b7ec3d4829"
    end
    resource "test_reads" do
      url "https://github.com/bcgsc/arcs/raw/master/Examples/arcs-long_test-demo/test_reads.fa.gz"
      sha256 "b42398c5828420ec54f0013f90148a2e82348e1fa8d591f1680741f47689a926"
    end

    assert_match "Usage", shell_output("#{bin}/arcs --help")
    assert_match "Usage", shell_output("#{bin}/long-to-linked-pe --help 2>&1")
    resources.each { |r| r.stage testpath }
    system "#{bin}/arcs-make", "arcs-long", "draft=test_scaffolds", "reads=test_reads_v2_1000-subsample",
           "m=8-10000", "s=70", "a=0.9", "l=3", "c=3"
  end
end
