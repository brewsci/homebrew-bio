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
    rebuild 4
    sha256 cellar: :any, arm64_golden_gate: "455c554679e607cea1d8e4abaa007913a47a11a2dac48a4576215b984521dd0c"
    sha256 cellar: :any, arm64_tahoe:       "858f1f0131a1ad63262b97fbc86c8b7c24671e3935c2b82149728b5727f86fac"
    sha256 cellar: :any, arm64_sequoia:     "699ed6e8a0b31ec712653d33b9ca51dc7eef32e17cc03e25c682614e0861f905"
    sha256 cellar: :any, x86_64_linux:      "ab3049a73e040e5577caa03b924312800ba5647cd7b57b8b07618f398a16e178"
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
