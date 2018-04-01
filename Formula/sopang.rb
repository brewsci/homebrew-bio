class Sopang < Formula
  desc "Exact pattern matching over a elastic-degenerate string"
  homepage "https://github.com/MrAlexSee/sopang"
  url "https://github.com/MrAlexSee/sopang/archive/v1.0.tar.gz"
  sha256 "b5e6404ed59a0cf81be4e1578149f829bdecab8ef9b91951c0193efe36606b06"
  head "https://github.com/MrAlexSee/sopang.git"

  depends_on "boost" => :build

  needs :cxx11

  def install
    system "make", "BOOST_DIR=#{Formula["boost"].opt_prefix}"
    bin.install "sopang"
    pkgshare.install "sample", "run_all.sh", "generate_synth.py"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/sopang -h 2>&1", 1)
  end
end
