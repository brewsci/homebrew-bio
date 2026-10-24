class Libccp4 < Formula
  desc "Protein X-ray crystallography toolkit"
  homepage "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/libccp4-8.0.0.tar.gz"
  sha256 "cb813ae86612a0866329deab7cee96eac573d81be5b240341d40f9ad5322ff2d"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 2
    sha256 arm64_golden_gate: "45ceae3f6a78c9617b103936c9b4a91b508a776460a77883034002fd115c5dbc"
    sha256 arm64_tahoe:       "96ed2fee39e1e871f05f0d7e798d991d4c1e8383e3b64e24fb6037ef19d9b443"
    sha256 arm64_sequoia:     "8b0a0de05886c5f0579f20f3be308f02f81d629744c1cf878be4cece8d4026c9"
    sha256 x86_64_linux:      "46bdd0c04e12125df57db952a0fc50179703502ab56ea927515114dd5cb6dc39"
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
