class ClustalW < Formula
  # cite Larkin_2007: "https://doi.org/10.1093/bioinformatics/btm404"
  desc "Multiple sequence alignment tool"
  homepage "http://www.clustal.org/clustal2/"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cd8e60b3e5302663fb451e97fcdb957b0cf1827d2a74a217278f42c201a71625" => :catalina
    sha256 "bcb7a339eb760fc0f14613ae2d231d1e15ade239fa3aefb2d02fb00705ffe92c" => :x86_64_linux
  end

  def install
    # missing #include <string> - reported to clustalw@ucd.ie Dec 11 2015
    inreplace "src/general/VectorOutOfRange.h",
      "#include <exception>",
      "#include <exception>\n#include<string>"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    bin.install_symlink "clustalw2" => "clustalw"
  end

  test do
    # we provide a non-existent option to avoid interactive mode
    assert_match version.to_s, shell_output("#{bin}/clustalw2 --fake 2>&1", 1)
  end
end
