class ClustalW < Formula
  # cite Larkin_2007: "https://doi.org/10.1093/bioinformatics/btm404"
  desc "Multiple sequence alignment tool"
  homepage "http://www.clustal.org/clustal2/"
  url "http://www.clustal.org/download/2.1/clustalw-2.1.tar.gz"
  sha256 "e052059b87abfd8c9e695c280bfba86a65899138c82abccd5b00478a80f49486"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426a34059e0c0247d9f7576322af141e8608c432518d8144c49faad01e95d722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d07f17471f77ef64bff195f5aee75256306b507ff5a257c67d25a1e65f15d5e"
    sha256 cellar: :any_skip_relocation, ventura:       "7d2437c7c93c54a41ade8fbd73b2263f228fefe9ec82b8498f21b580f572b58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96e6e3ed8d23bb1772c912b5d8767b735cb283f22868a1f28be69823121ebdb"
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
