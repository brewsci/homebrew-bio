class Kmc < Formula
  # cite Deorowicz_2015: "https://doi.org/10.1093/bioinformatics/btv022"
  desc "Fast and frugal disk based k-mer counter"
  homepage "https://github.com/refresh-bio/KMC"
  url "https://github.com/marekkokot/KMC.git",
  tag:      "v3.2.4",
  revision: "d6c24dc88010508336d824bbffbf1ef3f49fddf8"
  head "https://github.com/marekkokot/KMC.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "24d1279462ee5a954416c883be93d8dd7d4636c9812dabf66039a8be3957aa35"
    sha256 cellar: :any,                 ventura:      "cb7a250182a374d9d8bbf64a9119f212c72b1c4e532f86baf3bd9209a51c2b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eae18036038bd8d86937fc10abb769e3f61fcf3b8b484d5eefd5761378411146"
  end

  depends_on "pybind11" => :build
  depends_on "gcc"
  uses_from_macos "zlib"

  fails_with gcc: "11"

  def install
    if OS.mac?
      inreplace "Makefile" do |s|
        s.gsub! "-fsigned-char", "-fsigned-char -Wno-deprecated-declarations"
        s.gsub! "-static-libgcc -static-libstdc++", "-static-libgcc -static-libstdc++ -stdlib=libstdc++ -lstdc++"
      end
    else
      # On Linux, we need to link against libstdc++
      inreplace "Makefile", "-static -Wl,", "-lstdc++ -Wl,"
    end
    gcc_major_ver = Formula["gcc"].any_installed_version.major
    cc = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
    args = %W[CC=#{cc} KMC_BIN_DIR=#{bin}]
    system "make", *args, "kmc", "kmc_dump", "kmc_tools"
    bin.install Dir["bin/kmc*"]
    doc.install Dir["*.pdf"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kmc --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_dump --version 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kmc_tools 2>&1")
  end
end
