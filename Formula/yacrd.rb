class Yacrd < Formula
  desc "Yet Another Chimeric Read Detector"
  homepage "https://github.com/natir/yacrd"
  url "https://github.com/natir/yacrd/archive/v0.2.1.tar.gz"
  sha256 "4729d7554dcd0b6f148695bc0804d732a71e4ada4f2b1818b83c0e17da7392a8"

  needs :cxx11

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "yacrd"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacrd --version 2>&1")
  end
end
