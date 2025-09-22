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
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "73c3da560fe502537a897cda5570fe82e8639c8e6738749c1e0ccf08f79f28cd"
    sha256 cellar: :any,                 arm64_sequoia: "d5b1c2f96a5f8b25c181f4674509ffbfc848cbc569f7ba3027d344b6c3761284"
    sha256 cellar: :any,                 arm64_sonoma:  "b30cd0df31dbc1c940a74448a928473cdce7f731f9c4e705f8dab3169a621263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b6e9efa753487b11a84c1ceed365cef0718e229fa596769599dcfe7407e142"
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
