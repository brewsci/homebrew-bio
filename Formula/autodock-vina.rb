class AutodockVina < Formula
  # cite Eberhardt_2021: "https://10.1021/acs.jcim.1c00203"
  # cite Trott_2010: "https://10.1002/jcc.21334"
  include Language::Python::Virtualenv
  desc "Docking and virtual screening program"
  homepage "https://github.com/ccsb-scripps/AutoDock-Vina/"
  url "https://github.com/ccsb-scripps/AutoDock-Vina/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "038a2ade139eeb85b4bc7f5242fbc770f192427735e17bdc877b7420f39553d9"
  license "Apache-2.0"
  head "https://github.com/ccsb-scripps/AutoDock-Vina.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sequoia: "3dca204c40cf2b905c6565b2639025b9fdf0ad4a647d15cef46427c5160b5eba"
    sha256 cellar: :any,                 arm64_sonoma:  "4343e056f090acbea1369cdf6de0d4f6ad806635641e6f1bd2470ed7583b0204"
    sha256 cellar: :any,                 ventura:       "ff552f4ef58d5b4d7bdd6b8309b016d29414c2ee801567e035ba7c3ab520c804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3def676bdd665dd9a91660e5c1b0a7d9a2cfcfacebba5bfd4d5f7934ef66051"
  end

  depends_on "swig" => :build
  depends_on "boost@1.85"
  depends_on "python@3.13"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.13"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    binaries = ["vina", "vina_split"]
    inreplace "build/makefile_common", "$(BASE)", Formula["boost"].opt_prefix
    inreplace "build/makefile_common", "${BASE}", Formula["boost"].opt_prefix
    if OS.mac?
      cd "build/mac/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=$(shell brew --prefix)", "BASE=#{prefix}"
          s.gsub! "$(BASE)/include", Formula["boost"].opt_include
          s.gsub! "GPP=/usr/bin/clang++", "GPP=#{ENV.cxx}"
          s.gsub! "BOOST_STATIC=y", "BOOST_STATIC="
        end
        system "make"
        bin.install binaries
      end
    else
      cd "build/linux/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=/usr", "BASE=#{prefix}"
          s.gsub! "$(BASE)/include", Formula["boost"].opt_include
        end
        system "make"
        bin.install binaries
      end
    end
  end

  test do
    assert_match "AutoDock Vina v", shell_output("#{bin}/vina --help").chomp
    assert_match "AutoDock Vina PDBQT Split", shell_output("#{bin}/vina_split --help").chomp
  end
end
