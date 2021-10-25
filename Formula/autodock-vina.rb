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
    sha256 cellar: :any,                 catalina:     "49a9ef97499d33d5607a5b247b3b7bb3ad4828b660bce873f081a0b69ec514a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ebb375d43a962329c9a8b0f9e1a3540c66a60d0c3dd546ea6d3088fee7e7aec7"
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
