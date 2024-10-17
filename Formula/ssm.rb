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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "15a774231d4f3697b5c5abc53b2e17207215c21a6ff8e10df711a71d74275df4"
    sha256 cellar: :any,                 arm64_sonoma:  "ee10818fff8ff9a88f1e098f38277ffbad60c99901211b1fc8d182bdfa0aa8c7"
    sha256 cellar: :any,                 ventura:       "d3985386c0e0ecd59742ea9d6fdd49708e79e56e1ac95adad9c059c90f876dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fa7f2f25d9443cd3ce3071f3a7931b1e6c01ba1faa42ceb618a2092fb437dd"
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
