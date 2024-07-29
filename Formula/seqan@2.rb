class SeqanAT2 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "C++ library of sequence algorithms and data structures"
  homepage "https://www.seqan.de/"
  url "https://github.com/seqan/seqan/releases/download/seqan-v2.4.0/seqan-library-2.4.0.tar.xz"
  sha256 "dd97b1514ab83acb7d7be911b157979e188e8ca72cc61c430c1e0fd03bcd41a5"
  revision 1
  head "https://github.com/seqan/seqan.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4527296ec60eeb08aa0dd9e5cb3d213a1f5f2c3c176fff2f6640ee2dd243f956"
    sha256 cellar: :any_skip_relocation, ventura:      "8ddaecc16fd76991183396c4d8bb17b2f40ba61e2430e0decabface368618919"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e01ca06d8600b42480d510c7f29a8e42d987a93d03d79f51ba658a5dd4d8309"
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
