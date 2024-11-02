class AutodockVina < Formula
  # cite Eberhardt_2021: "https://10.1021/acs.jcim.1c00203"
  # cite Trott_2010: "https://10.1002/jcc.21334"
  include Language::Python::Virtualenv
  desc "Docking and virtual screening program"
  homepage "https://github.com/ccsb-scripps/AutoDock-Vina/"
  url "https://github.com/ccsb-scripps/AutoDock-Vina/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "38aec306bff0e47522ca8f581095ace9303ae98f6a64031495a9ff1e4b2ff712"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ccsb-scripps/AutoDock-Vina.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8db686a32dc49d24220979d8159c49e61ae69a5b2724b10313d4ed9ff85d18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84481205f261ae96bd35daceb6eff1d7c0476febb63a03e9e52b7ba3b81ba1c4"
    sha256 cellar: :any_skip_relocation, ventura:       "bc26eda9837eb112eb98d50284787f52f1fb3fd95c2fd67a9b1fd837ce9d31ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6415e5153ad43f3a2ffe51d1a5e57cff7689111733efdf72a5bc2bac60ea4f6f"
  end

  depends_on "swig" => :build
  depends_on "boost"
  depends_on "python@3.13"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.13"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    binaries = ["vina", "vina_split"]
    inreplace "build/makefile_common", "$(BASE)", Formula["boost"].opt_prefix
    inreplace "build/makefile_common", "${BASE}", Formula["boost"].opt_prefix
    # deprecated boost/filesystem/convenience.hpp and progress.hpp since boost 1.85
    inreplace "src/split/split.cpp", "#include <boost/filesystem/convenience.hpp> ", ""
    inreplace "src/lib/vina.h", "#include <boost/filesystem/convenience.hpp> ", ""
    inreplace "src/lib/parallel_progress.h" do |s|
      s.gsub! "#include <boost/progress.hpp>", "#include <boost/timer/progress_display.hpp>"
      s.gsub! "boost::progress_display", "boost::timer::progress_display"
    end
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
