class Minimap2 < Formula
  # cite Li_2018: "https://arxiv.org/abs/1708.01492"
  desc "Fast pairwise aligner for genomic and spliced nucleotide sequences"
  homepage "https://github.com/lh3/minimap2"
  url "https://github.com/lh3/minimap2/releases/download/v2.10/minimap2-2.10.tar.bz2"
  sha256 "52b36f726ec00bfca4a2ffc23036d1a2b5f96f0aae5a92fd826be6680c481c20"
  head "https://github.com/lh3/minimap2.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "011e0932718cd703c25e0dc7eb1d8981adcfb5073ebc7ab0a1dde699b926ca45" => :sierra_or_later
    sha256 "3014285111827c16f6954aa58bcbbc1e053449a1760989cb3af182f68e49c0f0" => :x86_64_linux
  end

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "minimap2"
    man1.install "minimap2.1"
    pkgshare.install "python", "test"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/minimap2 --help 2>&1")
  end
end
