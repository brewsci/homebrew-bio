class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.0.5/arcs-1.0.5.tar.gz"
  sha256 "367247aaa5bf431ee1379b9835d87ffeaa90fd40eb8d90837764d6f77c498b21"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "86575c9c23b7a1b299ba9d0550d93ab94e603a37e834324fbfd03288a2812580" => :sierra
    sha256 "9cadbe7d522ee3bd53b59a032159aa42fc67a3ae7d8bb5b3df1e8dc0c1ad55fa" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/arcs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-boost=#{Formula["boost"].opt_include}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/arcs --help")
  end
end
