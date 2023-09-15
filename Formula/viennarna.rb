class Viennarna < Formula
  # cite Lorenz_2011: "https://doi.org/10.1186/1748-7188-6-26"
  desc "Prediction and comparison of RNA secondary structures"
  homepage "https://www.tbi.univie.ac.at/RNA/"
  url "https://github.com/ViennaRNA/ViennaRNA/releases/download/v2.6.3/ViennaRNA-2.6.3.tar.gz"
  sha256 "6c10a68f1a73db8122aa45d68889988ea47ed1ecbee08829ac2fc6b9bb72570d"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "4edf24ac8964ff748439cf211a3f3d4a34a51ef28d2429de42a607d451f2fd6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64232367b889c918417a97f8274fca437556e18d89ce227898a56516e5b977ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "lapack"
  depends_on "mpfr"

  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  def install
    # Fix the error: RNA_wrap.cpp:763:10: fatal error: 'EXTERN.h' file not found
    # https://github.com/ViennaRNA/ViennaRNA/issues/111
    if OS.mac?
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      ENV["CPATH"] = "#{MacOS.sdk_path_if_needed}/#{perl_archlib}/CORE"
    end

    system "autoreconf", "-ivf"
    system "./configure",
      "--prefix=#{prefix}",
      "--with-cluster",
      "--with-kinwalker",
      "--without-python"
    system "make", "install"
  end

  test do
    assert_match "-1.30 MEA=21.31", pipe_output("#{bin}/RNAfold --MEA", "CGACGUAGAUGCUAGCUGACUCGAUGC")
  end
end
