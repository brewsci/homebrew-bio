class AutodockVina < Formula
  # cite Eberhardt_2021: "https://10.1021/acs.jcim.1c00203"
  # cite Trott_2010: "https://10.1002/jcc.21334"
  include Language::Python::Virtualenv
  desc "Docking and virtual screening program"
  homepage "https://github.com/ccsb-scripps/AutoDock-Vina/"
  url "https://github.com/ccsb-scripps/AutoDock-Vina/archive/v1.2.5.tar.gz"
  sha256 "38aec306bff0e47522ca8f581095ace9303ae98f6a64031495a9ff1e4b2ff712"
  license "Apache-2.0"
  head "https://github.com/ccsb-scripps/AutoDock-Vina.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 catalina:     "34c63eafaa1fed7aa322060b2e7f4226a9807ea5ab138e1c3d36c364a3c1eddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "752706c4bfde2ce4f437b0eaa6be4f10e6da801b2f771fe8d904c6c51a90266b"
  end

  depends_on "swig" => :build
  depends_on "boost"
  depends_on "python@3.11"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    binaries = ["vina", "vina_split"]
    inreplace "build/makefile_common", "$(BASE)", Formula["boost"].opt_prefix
    inreplace "build/makefile_common", "${BASE}", Formula["boost"].opt_prefix
    if OS.mac?
      cd "build/mac/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=/usr/local", "BASE=#{prefix}"
          s.gsub! "$(BASE)/include", Formula["boost"].opt_include
          s.gsub! "GPP=/usr/bin/clang++", "GPP=#{ENV.cxx}"
        end
        system "make"
        bin.install binaries
      end
    else
      cd "build/linux/release" do
        inreplace "Makefile" do |s|
          s.gsub! "BASE=/usr/local", "BASE=#{prefix}"
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
