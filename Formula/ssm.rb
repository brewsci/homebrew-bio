class Ssm < Formula
  # cite Krissinel_2004: "https://doi.org/10.1107/S0907444904026460"
  desc "Secondary-structure matching, tool for fast protein structure alignment"
  homepage "https://www2.mrc-lmb.cam.ac.uk"
  url "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/ssm-1.4.tar.gz"
  sha256 "56e7e64ed86d7d9ec59500fd34f26f881bdb9d541916d9a817c3bfb8cf0e9508"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "9b0270975c1c9f623df8439f3be3a8b2c641b60972761dc5b578fe9309b5a052"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "386e384fe826e6ecedf2efc9605acdd9a6e90f7cd8cf24c8ebdbd3e5f495beb2"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"

  def install
    # required to prevent flat namespace issues on macOS
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    # --enable-shared is required for coot
    args = %W[
      --prefix=#{prefix}
      --enable-ccp4
      --enable-shared
      --disable-static
    ]
    if OS.mac?
      inreplace "./configure", "${wl}-flat_namespace", ""
      inreplace "./configure", "${wl}-undefined ${wl}suppress", "-undefined dynamic_lookup"
    end
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags ssm")
  end
end
