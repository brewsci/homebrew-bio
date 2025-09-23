class ClustalW < Formula
  # cite Larkin_2007: "https://doi.org/10.1093/bioinformatics/btm404"
  desc "Multiple sequence alignment tool"
  homepage "http://www.clustal.org/clustal2/"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a8dbe6283c5fba496ca865be5fe221efb58ac35eed5c6591caff7c681d1c027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd49acf6241d5c909976d685b14704906a947541c9f0612c9d99792db38c3249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7302c77b486c1d5923cfcc9722faa58f66b6ba556c0281a7de9904ddc87860d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2153e925fae0faaeecf2eb439a89f867e109fab4d4964a294bb942b5f3dc8d"
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
