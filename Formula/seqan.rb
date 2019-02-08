class Seqan < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "C++ library of sequence algorithms and data structures"
  homepage "https://www.seqan.de/"
  url "https://github.com/seqan/seqan/releases/download/seqan-v2.4.0/seqan-library-2.4.0.tar.xz"
  sha256 "dd97b1514ab83acb7d7be911b157979e188e8ca72cc61c430c1e0fd03bcd41a5"
  head "https://github.com/seqan/seqan.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6d8fb5e40c810aa02affea2c6a1191cde5f3a91df30e29d02924970d180eda11" => :sierra
    sha256 "9943d2d86dbf1fad7d703ccd2236e5cefb6a7923436ca3af3bcd842ac874d13d" => :x86_64_linux
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
