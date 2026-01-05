class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/libccp4-8.0.0.tar.gz"
  sha256 "cb813ae86612a0866329deab7cee96eac573d81be5b240341d40f9ad5322ff2d"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_tahoe:   "0ea5b65efc2371d9e13b039b0be402da3bb702331fa36c36a6b70a6d9d88f7e0"
    sha256 arm64_sequoia: "edf211b7df112f7cd53750d4d6cf5b0c0aeefa4463767f7127a02245d3ade93c"
    sha256 arm64_sonoma:  "1a379e8e3a312e98b5135ca117345d90b9b2bf66c33193cdfd636c6badbf7e83"
    sha256 x86_64_linux:  "7e589a6c84ddefe61703bff691fd0eaac05b4143cfd9d7178a354dfa26cc76f6"
  end

  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "m4"

  def install
    # not fortran
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --disable-static
      --disable-fortran
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags ccp4c")
  end
end
