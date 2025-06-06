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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "7739f8c221a8755ab8827456d07fe5845a710f2647f0cc4000e300b183a5521f"
    sha256 cellar: :any,                 arm64_sonoma:  "b30cd0df31dbc1c940a74448a928473cdce7f731f9c4e705f8dab3169a621263"
    sha256 cellar: :any,                 ventura:       "0114c1137a337c95066ee7fb057281dfe9f0201f0fd3304bface44814b52c355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9a802fecc753eca036b07affe280f4c0d6a4881c2ebfa0131e52b0109a3770"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "brewsci/bio/libccp4"
  depends_on "brewsci/bio/mmdb2"

  def install
    # fix "invalid suffix on literal; C++11 requires a space between literal and identifier"
    inreplace "superpose.cpp" do |s|
      s.gsub! '" v."superpose_version" from "superpose_date" built', '" v.%s from %s built'
      s.gsub! ",ssm::MAJOR_VERSION", ",superpose_version, superpose_date, ssm::MAJOR_VERSION"
      s.gsub! '" Superpose v."superpose_version" from "superpose_date" "', '" Superpose v.%s from %s "'
      s.gsub! '------\n\n"', '------\n\n",superpose_version, superpose_date'
    end
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
