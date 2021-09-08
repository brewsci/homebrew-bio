class AutodockVina < Formula
  # cite Eberhardt_2021: "https://10.1021/acs.jcim.1c00203"
  # cite Trott_2010: "https://10.1002/jcc.21334"
  include Language::Python::Virtualenv
  desc "Docking and virtual screening program"
  homepage "https://github.com/ccsb-scripps/AutoDock-Vina/"
  url "https://github.com/ccsb-scripps/AutoDock-Vina/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "b9c28df478f90d64dbbb5f4a53972bddffffb017b7bb58581a1a0034fff1b400"
  license "Apache-2.0"
  head "https://github.com/ccsb-scripps/AutoDock-Vina.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "3ad1319e459e63e9b4c117cf30513fff43d672d6419deb4a6a1ac2c72219e5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "196365715bdf0dd75a6fc3249b4983a053f44eaa8068c34f3d774fd23b019f41"
  end

  depends_on "swig" => :build
  depends_on "boost"
  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    binaries = ["vina", "vina_split"]
    if OS.mac?
      cd "build/mac/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=/usr/local", "BASE=#{prefix}"
          s.gsub! "$(BASE)/include", Formula["boost"].opt_include.to_s
          s.gsub! "GPP=/usr/bin/clang++", "GPP=#{ENV.cxx}"
        end
        system "make"
        bin.install binaries
      end
    else
      cd "build/linux/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=/usr/local", "BASE=#{prefix}"
          s.gsub! "$(BASE)/include", Formula["boost"].opt_include.to_s
        end
        system "make"
        bin.install binaries
      end
    end
  end

  test do
    system "#{bin}/vina", "--help"
    system "#{bin}/vina_split", "--help"
  end
end
