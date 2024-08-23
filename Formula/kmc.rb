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
    sha256 cellar: :any,                 big_sur:      "79dc862a0ee19b5617e021b2f74b3168144bd7951c99eaeb524994b65fee771d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cb51b8cbbedfba92900e56910d4b8ecd6754891dcdc1a7a0d47d6335ace73076"
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
