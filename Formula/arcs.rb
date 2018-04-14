class Arcs < Formula
  # cite Yeo_2017: "https://doi.org/10.1093/bioinformatics/btx675"
  desc "Scaffold genome sequence assemblies using 10x Genomics data"
  homepage "https://github.com/bcgsc/arcs"
  url "https://github.com/bcgsc/arcs/releases/download/v1.0.3/arcs-1.0.3.tar.gz"
  sha256 "85973989da98ea9071c93f00cf4182b359e7f576414e1cbb02ca581d9016368f"
  head "https://github.com/bcgsc/arcs.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "79b87cd3e692a479594eed4e0b1dcf59b7880626ff2320c71a83a4fb465c6bc6" => :sierra_or_later
    sha256 "ec7b96c3e5773bd903f8ba845447ae540d82bce80684c98ebcd34d2d64d1275d" => :x86_64_linux
  end

  head do
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
