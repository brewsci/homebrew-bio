class Seqan < Formula
  desc "C++ library of sequence algorithms and data structures"
  homepage "https://www.seqan.de/"
  url "https://github.com/seqan/seqan/releases/download/seqan-v2.4.0/seqan-library-2.4.0.tar.xz"
  sha256 "dd97b1514ab83acb7d7be911b157979e188e8ca72cc61c430c1e0fd03bcd41a5"
  head "https://github.com/seqan/seqan.git"
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"

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
    # seqan-library installs only header files, so we test if version.h exists and has the right version number.
    assert_predicate include/"seqan/version.h", :exist?
    assert_match "SEQAN_VERSION_MAJOR", File.read(include/"seqan/version.h")
  end
end
