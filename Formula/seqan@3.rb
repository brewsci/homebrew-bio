class SeqanAT3 < Formula
  # cite D_ring_2008: "https://doi.org/10.1186/1471-2105-9-11"
  # cite Reinert_2017: "https://doi.org/10.1016/j.jbiotec.2017.07.017"
  desc "The modern C++ library for sequence analysis"
  homepage "https://www.seqan.de"
  url "https://github.com/seqan/seqan3/archive/3.0.1.tar.gz"
  sha256 "fcf481c7989c2438857ac58eaac3a5c21447c3936bbaf9b2f9f20847da50258b"
  head "https://github.com/seqan/seqan3.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a1a8dc4e5bb64b19e4267c4ed23be3a6db8ce6e23f7278e0d1e1b9858a14cb56" => :catalina
    sha256 "4085365e99e200e876c473a1530c46d3369ad7c8896f70b22d377360c2310fe6" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "xz" => :build

  def install
    system "cmake", "test/documentation/"
    system "make", "doc_usr"

    include.install "include/seqan3"
    doc.install Dir["#{buildpath}/doc_usr/html/*"]
  end

  test do
    assert_match "SEQAN3_VERSION_MAJOR", File.read(include/"seqan3/version.hpp")
  end
end
