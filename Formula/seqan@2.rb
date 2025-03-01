class SeqanAT2 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "C++ library of sequence algorithms and data structures"
  homepage "https://www.seqan.de/"
  url "https://github.com/seqan/seqan/releases/download/seqan-v2.5.0/seqan-library-2.5.0.tar.xz"
  sha256 "03a605e44d60e0a04b5822db4abd590f252012b2c579fd1167a09daeba758fce"
  head "https://github.com/seqan/seqan.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620aecc7747d6704f86da98f35363ccb0a065d572d285df9dc40aaeeaf658336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620aecc7747d6704f86da98f35363ccb0a065d572d285df9dc40aaeeaf658336"
    sha256 cellar: :any_skip_relocation, ventura:       "04779cfb31863ab1a1653a8fc79aafdba555e0482ea111a5bf2e41606e9039e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7863f28a47bf97fd560599cad279139e91728ee6f3fc95142834d2ded70f64fb"
  end

  def install
    include.install "include/seqan"
    if build.head?
      prefix.install_metafiles
      pkgshare.install Dir["*"]
    else
      prefix.install_metafiles "share/doc/seqan"
      doc.install Dir["share/doc/seqan/*"]
      lib.install "share/pkgconfig", "share/cmake"
    end
  end

  test do
    # seqan-library installs only header files, so check contents of version.h.
    assert_match "SEQAN_VERSION_MAJOR", File.read(include/"seqan/version.h")
  end
end
