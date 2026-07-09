class Goleft < Formula
  desc "Tools for BAM/CRAM QC, coverage and indexcov"
  homepage "https://github.com/brentp/goleft"
  url "https://github.com/brentp/goleft/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "0c563edea898059a75adf6250149643bdc61e4660544fabafbaefc09b4c9d1b3"
  license "MIT"
  head "https://github.com/brentp/goleft.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"goleft"), "./cmd/goleft"
  end

  test do
    assert_match "goleft Version: #{version}", shell_output("#{bin}/goleft 2>&1", 1)
    assert_match "indexcov", shell_output("#{bin}/goleft 2>&1", 1)
  end
end
