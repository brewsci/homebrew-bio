class Openstructure < Formula
  desc "Modular software framework for molecular modelling and visualization"
  homepage "https://openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.9.3/openstructure-2.9.3.tar.gz"
  sha256 "b5958ada252a3912a71da0cefb0313a4291ac6b17c93d6e0a61d361ee62de92e"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "clustal-w"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "parasail"
  depends_on "python@3.10"
  depends_on "sip"
  depends_on "sqlite3"

  resource "components" do
    url "https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz"
    sha256 "9efba276fc378cde50a2e3dfe27390f0737059c29ea12019d20cfc978f76bf74"
  end

  def python3
    "python3.10"
  end

  def install
    xy = Language::Python.major_minor_version python3
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system python3, "-m", "pip", "install", "--prefix=#{libexec}", "numpy", "pandas", "scipy", "networkx", "OpenMM"

    mkdir "build" do
      puts xy
      args = std_cmake_args + %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DCMAKE_BUILD_TYPE=Release
        -DOPTIMIZE=1
        -DENABLE_MM=1
        -DOPEN_MM_LIBRARY=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib
        -DOPEN_MM_INCLUDE_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/include
        -DOPEN_MM_PLUGIN_DIR=#{libexec}/lib/python#{xy}/site-packages/OpenMM.libs/lib/plugins
        -DENABLE_PARASAIL=1
        -DCOMPILE_TMTOOLS=1
        -DENABLE_GFX=1
        -DENABLE_GUI=0
        -DENABLE_INFO=0
      ]
      system "cmake", "..", *args
      system "make", "-j", ENV.make_jobs

      resource("components").stage do
        system "stage/bin/chemdict_tool", "create",
               "components.cif.gz", "compounds.chemlib",
               "pdb", "-i"
        system "stage/bin/chemdict_tool", "update",
               buildpath/"modules/conop/data/charmm.cif",
               "compounds.chemlib", "charmm"
      end

      # Re-configure with compound library
      system "cmake", "..",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}",
             "-DCMAKE_BUILD_TYPE=Release",
             "-DCOMPOUND_LIB=#{buildpath}/build/compounds.chemlib",
             *std_cmake_args
      system "make", "-j", ENV.make_jobs
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ost -h")
  end
end
