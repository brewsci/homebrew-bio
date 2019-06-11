class Stacks < Formula
  # cite Catchen_2011: "https://doi.org/10.1534/g3.111.000240"
  # cite Catchen_2013: "https://doi.org/10.1111/mec.12354"
  desc "Pipeline for building loci from short-read sequences"
  homepage "http://catchenlab.life.illinois.edu/stacks/"
  url "http://catchenlab.life.illinois.edu/stacks/source/stacks-2.4.tar.gz"
  sha256 "30093d688a2dc62a19ea42a58065f024c8279419439049bcde186703e75641c1"

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

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
