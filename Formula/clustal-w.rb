class ClustalW < Formula
  # cite Larkin_2007: "https://doi.org/10.1093/bioinformatics/btm404"
  desc "Multiple sequence alignment tool"
  homepage "http://www.clustal.org/clustal2/"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "139b2529b61a2f66e40721e7ee87256c107e5f5deabcafb80fb3a111283b22e5" => :sierra
    sha256 "1151984c5e8e98359dc213234c9759eae9504d91d3c9d9003ad12f3cbe24d048" => :x86_64_linux
  end

  def install
    # missing #include <string> - reported to clustalw@ucd.ie Dec 11 2015
    inreplace "src/general/VectorOutOfRange.h",
      "#include <exception>",
      "#include <exception>\n#include<string>"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # we provide a non-existent option to avoid interactive mode
    assert_match version.to_s, shell_output("#{bin}/clustalw2 --fake 2>&1", 1)
  end
end
