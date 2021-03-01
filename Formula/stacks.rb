class Stacks < Formula
  # cite Catchen_2011: "https://doi.org/10.1534/g3.111.000240"
  # cite Catchen_2013: "https://doi.org/10.1111/mec.12354"
  desc "Pipeline for building loci from short-read sequences"
  homepage "http://catchenlab.life.illinois.edu/stacks/"
  url "catchenlab.life.illinois.edu/stacks/source/stacks-2.41.tar.gz"
  sha256 "78be911e083482aea321824b21bbd1cf7548aaf67768ca2073b280257f068260"
  license "GPL-3.0"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any, sierra:       "9387a6190454b83f17ac5c179abc67382592fa64d00b8c0f6293a5b0100ca117"
    sha256 cellar: :any, x86_64_linux: "06ca98f340aeacd4b0f47d7f3025b73b868289f0f8ff861306c15d13bfc3755b"
  end

  depends_on "gcc" if OS.mac? # needs openmp

  uses_from_macos "zlib"

  fails_with :clang # needs openmp

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ustacks --version 2>&1", 1)
  end
end
