class StormMerger < Formula
  desc "Scalable tool for merging PE reads with variable insert sizes"
  homepage "https://bitbucket.org/yaoornl/align_test"
  url "https://bitbucket.org/yaoornl/align_test/get/b514ea318f23.zip"
  version "1.5"
  sha256 "684e1dd6b95a0943cbaf769708386a6c3d3b2b5d792d65e404f8a43b4592c00d"

  depends_on "gcc" # needs -fopenmp
  depends_on "libomp" if OS.mac?

  fails_with "clang" # needs -fopenmp

  def install
    cd "align_test/Release" do
      system "make"
      bin.install "storm"
    end
  end

  test do
    assert_match "hash", shell_output("#{bin}/storm -h 2>&1")
  end
end
