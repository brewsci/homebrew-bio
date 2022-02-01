class AutodockVina < Formula
  # cite Eberhardt_2021: "https://10.1021/acs.jcim.1c00203"
  # cite Trott_2010: "https://10.1002/jcc.21334"
  include Language::Python::Virtualenv
  desc "Docking and virtual screening program"
  homepage "https://github.com/ccsb-scripps/AutoDock-Vina/"
  url "https://github.com/ccsb-scripps/AutoDock-Vina/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "22f85b2e770b6acc363429153b9551f56e0a0d88d25f747a40d2f55a263608e0"
  license "Apache-2.0"
  head "https://github.com/ccsb-scripps/AutoDock-Vina.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "34c63eafaa1fed7aa322060b2e7f4226a9807ea5ab138e1c3d36c364a3c1eddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "752706c4bfde2ce4f437b0eaa6be4f10e6da801b2f771fe8d904c6c51a90266b"
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
